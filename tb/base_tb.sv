`timescale 1ns/1ps

`define START_TESTBENCH error = 0; #10;
`define FINISH_WITH_FAIL #10; $finish();
`define FINISH_WITH_PASS #10; $finish();

module base_tb;

    // =========================================================================
    // Parameters
    // =========================================================================
    parameter real period     = 10.0;
    parameter real duty_cycle = 0.49;

    // =========================================================================
    // Signal declarations
    // =========================================================================
    reg  D, E, R;
    wire clk_1, clk_2;         // wire: driven by clkgen module, not reg
    reg  default_clk;

    logic Q_golden;
    logic Q_clkgate;
    logic Q_recirc;

    // Dedicated signals for golden model so force doesn't bleed to DUTs
    reg  D_g, E_g, R_g;

    int  same_phase;
    int  error;
    reg  stimulus_done;

    // =========================================================================
    // Clock generators
    // =========================================================================
    single_clkgen #(.period_p(period))
        single_clkgen_inst (.default_clk(default_clk));

    two_phase_clkgen #(.period_p(period), .duty_cycle_p(duty_cycle))
        clk_gen (.clk_1(clk_1), .clk_2(clk_2));

    // =========================================================================
    // DUTs
    // =========================================================================
    latch_clkgate  clkgate_dut (.D(D), .clk_1(clk_1), .clk_2(clk_2), .E(E), .R(R), .Q(Q_clkgate));
    latch_recircmux recirc_dut (.D(D), .clk_1(clk_1), .clk_2(clk_2), .E(E), .R(R), .Q(Q_recirc));

    // Golden model uses its own dedicated inputs
    golden golden_inst (.D(D_g), .C(default_clk), .E(E_g), .R(R_g), .Q(Q_golden));

    // =========================================================================
    // Mirror DUT inputs to golden during single-phase
    // =========================================================================
    always @(*) begin
        if (same_phase) begin
            D_g = D;
            E_g = E;
            R_g = R;
        end
    end

    // =========================================================================
    // Checkers
    // =========================================================================

    // Single-phase: compare both DUTs against golden
    always @(posedge default_clk) begin
        #1;
        if (same_phase) begin
            if (Q_clkgate !== Q_golden) begin
                $display("[ERROR] @%0t SINGLE-PHASE: Q_clkgate=%b != Q_golden=%b (D=%b E=%b R=%b)",
                         $time, Q_clkgate, Q_golden, D, E, R);
                error <= error + 1;
            end
            if (Q_recirc !== Q_golden) begin
                $display("[ERROR] @%0t SINGLE-PHASE: Q_recirc=%b  != Q_golden=%b (D=%b E=%b R=%b)",
                         $time, Q_recirc, Q_golden, D, E, R);
                error <= error + 1;
            end
        end
    end

    // Alt-phase: compare the two DUTs against each other (golden is disabled)
    always @(posedge clk_1 or posedge clk_2) begin
        #1;
        if (!same_phase) begin
            if (Q_clkgate !== Q_recirc) begin
                $display("[ERROR] @%0t ALT-PHASE: Q_clkgate=%b != Q_recirc=%b (D=%b E=%b R=%b)",
                         $time, Q_clkgate, Q_recirc, D, E, R);
                error <= error + 1;
            end
        end
    end

    // =========================================================================
    // Stimulus tasks
    // =========================================================================
    task automatic random_tests_singlephase;
        input int num_tests;
        repeat(num_tests) begin
            @(negedge default_clk); #1;
            R = $urandom_range(0,1);
            D = $urandom_range(0,1);
            E = $urandom_range(0,1);
        end
    endtask

    task automatic send_data_singlephase;
        input int num_tests;
        repeat(num_tests) begin
            @(negedge default_clk); #1;
            D = $urandom_range(0,1);
        end
    endtask

    task automatic enable_transitions_singlephase;
        input int num_tests;
        repeat(num_tests) begin
            @(negedge default_clk); #1;
            E = ~E;
            D = $urandom_range(0,1);
        end
    endtask

    task automatic random_tests_altphase;
        input int num_tests;
        repeat(num_tests) begin
            @(negedge clk_1); #1;
            D = $urandom_range(0,1);
            E = $urandom_range(0,1);
            R = $urandom_range(0,1);

            @(negedge clk_2); #1;
            D = $urandom_range(0,1);
            E = $urandom_range(0,1);
            R = $urandom_range(0,1);
        end
    endtask

    // =========================================================================
    // Stimulus
    // =========================================================================
    initial begin
        `START_TESTBENCH
        `ifdef VERILATOR
            $dumpfile({`VCD_DIR, `TARGET_NAME, "_verilator_dump.vcd"});
        `else
            $dumpfile({`VCD_DIR, `TARGET_NAME, "_icarus_dump.vcd"});
        `endif
        $dumpvars(0, base_tb);

        stimulus_done = 0;
        same_phase    = 1;
        D = 0; E = 0; R = 0;
        force Q_clkgate = '0;
        force Q_recirc = '0;

        #(period * 5);
        release Q_clkgate;
        release Q_recirc;

        // ----- Single-phase tests -----
        $display("\n=== Single-Phase Test ===");
        $display("[INFO] Running %0d random tests", `NUM_TESTS);
        #10 random_tests_singlephase(`NUM_TESTS);

        $display("[INFO] Hold behavior test (E=1 then E=0)");
        @(negedge default_clk); E = 1; D = 1; #1;
        repeat(3) @(negedge default_clk);
        @(negedge default_clk); E = 0; #1;
        send_data_singlephase(`NUM_TESTS);

        $display("[INFO] Rapid data transitions (E=1)");
        @(negedge default_clk); E = 1; #1;
        send_data_singlephase(`NUM_TESTS);

        $display("[INFO] Enable transitions");
        enable_transitions_singlephase(`NUM_TESTS);

        #(period * 5);

        // ----- Alt-phase tests -----
        $display("\n=== Alternating Phase Test ===");
        same_phase = 0;
        #(period * 3);

        // Disable golden: force dedicated inputs to X and kill its clock
        `ifndef VERILATOR
            force D_g = 'x;
            force E_g = 'x;
            force R_g = 'x;
            force single_clkgen_inst.default_clk = 'x;
        `endif

        $display("[INFO] Running %0d alternating-phase tests", `NUM_TESTS);
        random_tests_altphase(`NUM_TESTS);

        // ----- Finish -----
        stimulus_done = 1;
        #(period * 3);  // let checker catch any final errors
        if (error == 0) begin
            $display("[INFO] All checks passed!");
            `FINISH_WITH_PASS
        end else begin
            $display("[FAIL] %0d errors detected", error);
            `FINISH_WITH_FAIL
        end
    end

    // =========================================================================
    // Conditions
    // =========================================================================
    initial begin
        $display("\nComputed Conditions:");
        $display("  IS_SDFFE_PP0P = %d", `IS_SDFFE_PP0P);
        $display("  IS_SDFFE_PN0P = %d", `IS_SDFFE_PN0P);
        $display("  IS_DFFE_PP    = %d", `IS_DFFE_PP);
        $display("  IS_SDFF_PP0   = %d", `IS_SDFF_PP0);
        $display("  IS_SDFF_PN0   = %d", `IS_SDFF_PN0);
        $display("  IS_SDFF_PP1   = %d", `IS_SDFF_PP1);
        $display("  IS_SDFF_PN1   = %d", `IS_SDFF_PN1);
    end

    // =========================================================================
    // Final summary
    // =========================================================================
    final begin
        $display("\nSimulation time: %0t", $time);
        if (error == 0) begin
            $display("\033[0;32m    ____  ___   __________\033[0m");
            $display("\033[0;32m   / __ \\/   | / ___/ ___/\033[0m");
            $display("\033[0;32m  / /_/ / /| | \\__ \\\\__ \\ \033[0m");
            $display("\033[0;32m / ____/ ___ |___/ /__/ / \033[0m");
            $display("\033[0;32m/_/   /_/  |_/____/____/  \033[0m");
            $display("Simulation Succeeded!");
        end else begin
            $display("\033[0;31m    ______                    \033[0m");
            $display("\033[0;31m   / ____/_____________  _____\033[0m");
            $display("\033[0;31m  / __/ / ___/ ___/ __ \\/___/\033[0m");
            $display("\033[0;31m / /___/ /  / /  / /_/ / /    \033[0m");
            $display("\033[0;31m/_____/_/  /_/   \\____/_/     \033[0m");
            $display("Simulation Failed! (%0d errors)", error);
        end
    end

endmodule
