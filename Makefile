MKFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

CONFIGS = _DFFE_PP_ _SDFFE_PN0P_ _SDFFE_PP0P_ _SDFF_PP0_ _SDFF_PP1_ _DFFE_PP0P_ \
	_SDFF_PN1_ _SDFF_PN0_ _DFF_PP0_ _DFF_N_

# TODO: only verified through clkgate
CONFIGS+= _DFF_PN1_ _DFF_NN0_ _SDFFCE_PN0P_ _DFFE_PN0P_ _DFFE_PN1P_

PLATFORM ?= sky130hd

SHARED_RTL = $(wildcard $(MKFILE_DIR)shared/*.sv) \
			 $(wildcard $(MKFILE_DIR)platforms/$(PLATFORM)/*.v) \
			 $(wildcard $(MKFILE_DIR)simcells/*.sv) \
			 $(MKFILE_DIR)config.svh

MODULES = latch_clkgate latch_recircmux

VCD_DIR = $(MKFILE_DIR)vcd/$(CONFIG)
SCHEMATIC_DIR = $(MKFILE_DIR)schematics/$(CONFIG)

ICARUS_FLAGS = -g2012 -Wall -Wno-timescale
VERILATOR_FLAGS = --binary --trace --timing \
	-Wall -Wno-DECLFILENAME -Wno-fatal -Wno-WIDTHTRUNC

PLATFORM_UPPER = $(shell echo '$(PLATFORM)' | tr '[:lower:]' '[:upper:]')

.PHONY: $(CONFIGS) all icarus verilator clean view view-icarus view-verilator schematic help debug sim

# simulation runner
define run_tb
	RTL_SOURCES="$(wildcard $(MKFILE_DIR)rtl/$(1)/*.sv) $(SHARED_RTL)" \
	TB_MODULE="$(strip $(1))_tb" \
	TARGET_NAME="$(3)_$(strip $(2))" \
	TB_SOURCE="$(strip $(MKFILE_DIR)tb/$(1)_tb.sv)" \
	CONFIG=$(3) \
	$(MAKE) --no-print-directory _do_sim
endef

$(CONFIGS):
ifdef TB
	$(call run_tb,$(TB),$(DIR),$@)
else
	$(call run_tb,base,base,$@)
	$(call run_tb,series,series,$@)
	$(call run_tb,series,series_retimed,$@)
	$(call run_tb,tree,tree,$@)
endif

.PHONY: all
all:
	@for _config in $(CONFIGS); do \
		$(MAKE) $$_config; \
	done

_do_sim:
	@mkdir -p $(VCD_DIR)
	@iverilog $(ICARUS_FLAGS) \
		-D$(CONFIG) \
		-DTARGET_NAME=\"$(TARGET_NAME)\" \
		-DVCD_DIR=\"$(VCD_DIR)/\" \
		-D$(PLATFORM_UPPER) \
		-o icarus_sim $(RTL_SOURCES) $(TB_SOURCE)
	@vvp icarus_sim
	@verilator $(VERILATOR_FLAGS) \
		--top-module $(TB_MODULE) \
		-DVERILATOR \
		-D$(CONFIG) \
		-DVCD_DIR=\"$(VCD_DIR)/\" \
		-D$(PLATFORM_UPPER) \
		-DTARGET_NAME=\"$(TARGET_NAME)\" \
		-o V$(TB_MODULE) \
		$(RTL_SOURCES) $(TB_SOURCE)
	@./obj_dir/V$(TB_MODULE) || true

schematic:
ifndef CONFIG
	$(error CONFIG is not set.)
endif
ifndef DIR
	$(error DIR is not set.)
endif
	mkdir -p $(SCHEMATIC_DIR)
	@echo "Generating schematics for config $(CONFIG) platform $(PLATFORM_UPPER) in rtl/$(DIR)..."
	@for module in $(DUT_MODULES); do \
		echo "  Processing $$module..."; \
		yosys -q -p "read_verilog -sv -D$(CONFIG) -D$(PLATFORM_UPPER) $(MKFILE_DIR)rtl/$(DIR)/*.sv $(filter-out %clkgen.sv,$(SHARED_RTL)); \
			hierarchy -check -top $$module; proc; opt; clean; rmports; opt_clean -purge; \
			show -notitle -stretch -format dot -prefix $(SCHEMATIC_DIR)/$${module}_$(DIR) $$module" 2>&1 | grep -v "Warning:" || true; \
		if [ -f $(SCHEMATIC_DIR)/$${module}_$(DIR).dot ]; then \
			dot -Tpdf $(SCHEMATIC_DIR)/$${module}_$(DIR).dot -o $(SCHEMATIC_DIR)/$${module}_$(DIR).pdf; \
		fi; \
	done
	@rm -f $(SCHEMATIC_DIR)/*.dot
	@echo "Schematics saved to $(SCHEMATIC_DIR)/"

clean:
	rm -rf icarus_sim obj_dir schematics *.vcd *.fst *.log vcd

.PHONY: test
test:
	$(MAKE) --no-print-directory _do_sim \
		TARGET_NAME=sandbox \
		TB_MODULE=sandbox_tb \
		TB_SOURCE=$(MKFILE_DIR)tb/sandbox_tb.sv \
		RTL_SOURCES="$(wildcard $(MKFILE_DIR)rtl/sandbox/*.sv) $(SHARED_RTL)" \
		CONFIG=sandbox

