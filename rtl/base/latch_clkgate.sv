`timescale 1ns/1ps
`include "config.svh"

module latch_clkgate 
(
    input  wire D,
    input  wire clk_1,
    input  wire clk_2,
    input  wire E,
    input  wire R,
    output wire Q
);
    wire mux_output;
    wire gated_clk_2_en;
    wire latch_output;
    wire latched_en;
    wire latched_rst;
    wire gated_rst;

`ifdef _DFFE_PP_
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .Q(latched_en), .E(clk_1));
    
    assign latched_rst = 1'b0;
    assign gated_clk_2_en = latched_en & clk_2;
    
    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_1), .Q(latch_output));
    
    assign mux_output = latch_output;
    
    _DLATCH_P_ main_latch 
    (.D(mux_output), .E(gated_clk_2_en), .Q(Q));

`elsif _SDFFE_PP0P_
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .Q(latched_en), .E(clk_1));
    
    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    assign gated_clk_2_en = (latched_en | latched_rst) & clk_2;
    
    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_1), .Q(latch_output));
    
    _MUX_ mux_rst_inst 
    (.Y(mux_output), .A(latch_output), .B(1'b0), .S(latched_rst));
    
    _DLATCH_P_ main_latch 
    (.D(mux_output), .E(gated_clk_2_en), .Q(Q));

`elsif _SDFFE_PN0P_
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .Q(latched_en), .E(clk_1));
    
    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    assign gated_clk_2_en = (latched_en | ~latched_rst) & clk_2;
    
    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_1), .Q(latch_output));
    
    _MUX_ mux_rst_inst 
    (.Y(mux_output), .A(1'b0), .B(latch_output), .S(latched_rst));
    
    _DLATCH_P_ main_latch 
    (.D(mux_output), .E(gated_clk_2_en), .Q(Q));

`elsif _DFFE_PP0P_
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .Q(latched_en), .E(clk_1));
    
    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    assign gated_clk_2_en = latched_en & clk_2;
    
    _DLATCH_PN0_ secondary_latch 
    (.D(D), .E(clk_1), .R(~R), .Q(latch_output));
    
    _DLATCH_PN0_ main_latch 
    (.D(latch_output), .E(gated_clk_2_en), .R(~latched_rst), .Q(Q));

`elsif _SDFF_PP0_
    assign latched_en = 1'b1;
    
    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    assign gated_clk_2_en = (latched_en | latched_rst) & clk_2;
    
    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_1), .Q(latch_output));
    
    _MUX_ mux_rst_inst 
    (.Y(mux_output), .A(latch_output), .B(1'b0), .S(latched_rst));
    
    _DLATCH_P_ main_latch 
    (.D(mux_output), .E(gated_clk_2_en), .Q(Q));

`elsif _SDFF_PP1_
    assign latched_en = 1'b1;
    
    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    assign gated_clk_2_en = clk_2;
    
    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_1), .Q(latch_output));
    
    _MUX_ mux_set_inst 
    (.Y(mux_output), .A(latch_output), .B(1'b1), .S(latched_rst));
    
    _DLATCH_P_ main_latch 
    (.D(mux_output), .E(gated_clk_2_en), .Q(Q));

`elsif _DFF_N_
    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_2), .Q(latch_output));
    
    _DLATCH_P_ main_latch 
    (.D(latch_output), .E(clk_1), .Q(Q));

`elsif _DFF_PP0_
    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    _DLATCH_PN0_ secondary_latch 
    (.D(D), .E(clk_1), .R(~R), .Q(latch_output));
    
    _DLATCH_PN0_ main_latch 
    (.D(latch_output), .E(clk_2), .R(~latched_rst), .Q(Q));
`elsif _SDFF_PN0_

    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_1), .Q(latch_output));
    
    _MUX_ mux_rst_inst 
    (.Y(mux_output), .A(1'b0), .B(latch_output), .S(latched_rst));
    
    _DLATCH_P_ main_latch 
    (.D(mux_output), .E(clk_2), .Q(Q));

`elsif _SDFF_PN1_

    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_1), .Q(latch_output));
    
    _MUX_ mux_rst_inst 
    (.Y(mux_output), .A(1'b1), .B(latch_output), .S(latched_rst));
    
    _DLATCH_P_ main_latch 
    (.D(mux_output), .E(clk_2), .Q(Q));

`elsif _DFF_PN1_
    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_1), .Q(latch_output));

    _MUX_ mux_rst_inst 
    (.Y(mux_output), .A(1'b1), .B(latch_output), .S(latched_rst));    

    assign gated_clk_2_en = clk_2 || ~R;

    _DLATCH_P_ main_latch 
    (.D(mux_output), .E(gated_clk_2_en), .Q(Q));

`elsif _DFF_NN0_
    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    _DLATCH_PN0_ secondary_latch 
    (.D(D), .E(clk_2), .R(R), .Q(latch_output));
    
    _DLATCH_PN0_ main_latch 
    (.D(latch_output), .E(clk_1), .R(latched_rst), .Q(Q));

`elsif _DFFE_PN0P_
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .Q(latched_en), .E(clk_1));
    
    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    assign gated_clk_2_en = (latched_en | ~latched_rst) & clk_2;
    
    _DLATCH_PN0_ secondary_latch 
    (.D(D), .E(clk_1), .R(R), .Q(latch_output));

    _DLATCH_PN0_ main_latch 
    (.D(latch_output), .E(gated_clk_2_en), .R(latched_rst), .Q(Q));

`elsif _SDFFCE_PP0P_
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .Q(latched_en), .E(clk_1));
    
    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    assign gated_clk_2_en = latched_en & clk_2;
    
    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_1), .Q(latch_output));

    assign gated_rst = latched_en & latched_rst;

    _MUX_ mux_rst_inst 
    (.Y(mux_output), .A(latch_output), .B(1'b0), .S(gated_rst));    
    
    _DLATCH_P_ main_latch 
    (.D(mux_output), .E(gated_clk_2_en), .Q(Q));

`elsif _SDFFCE_PP1P_
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .Q(latched_en), .E(clk_1));
    
    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    assign gated_clk_2_en = latched_en & clk_2;
    
    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_1), .Q(latch_output));

    assign gated_rst = latched_en & latched_rst;

    _MUX_ mux_rst_inst 
    (.Y(mux_output), .A(latch_output), .B(1'b1), .S(gated_rst));    
    
    _DLATCH_P_ main_latch 
    (.D(mux_output), .E(gated_clk_2_en), .Q(Q));

`elsif _SDFFCE_PN0P_
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .Q(latched_en), .E(clk_1));
    
    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    assign gated_clk_2_en = latched_en & clk_2;
    
    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_1), .Q(latch_output));

    assign gated_rst = latched_en & latched_rst;

    _MUX_ mux_rst_inst 
    (.Y(mux_output), .A(1'b0), .B(latch_output), .S(gated_rst));    
    
    _DLATCH_P_ main_latch 
    (.D(mux_output), .E(gated_clk_2_en), .Q(Q));


`elsif _DFFE_PN1P_
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .Q(latched_en), .E(clk_1));
    
    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    assign gated_clk_2_en = (latched_en | ~latched_rst) & clk_2;
    assign gated_rst = gated_clk_2_en | ~latched_rst;

    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_1), .Q(latch_output));

    _MUX_ mux_rst_inst 
    (.Y(mux_output), .A(1'b1), .B(latch_output), .S(latched_rst));    
    
    _DLATCH_P_ main_latch 
    (.D(mux_output), .E(gated_rst), .Q(Q));

`else
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .Q(latched_en), .E(clk_1));
    
    assign latched_rst = 1'b0;
    assign gated_clk_2_en = latched_en & clk_2;
    
    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_1), .Q(latch_output));
    
    assign mux_output = latch_output;
    
    _DLATCH_P_ main_latch 
    (.D(mux_output), .E(gated_clk_2_en), .Q(Q));
`endif

endmodule
