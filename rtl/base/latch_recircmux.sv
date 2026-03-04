`timescale 1ns/1ps
`include "config.svh"

module latch_recircmux 
(
    input  wire D,
    input  wire clk_1,
    input  wire clk_2,
    input  wire E,
    input  wire R,
    output wire Q
);
    wire mux_latch_output_1;
    wire mux_latch_output_2;
    wire mux_output_1;
    wire mux_output_2;
    wire mux_output_3;
    wire mux_output_4;
    wire feedback_1;
    wire feedback_2;
    wire latched_en;
    wire latched_rst;
    wire mux_latch_output;

`ifdef _DFFE_PP_
    _DLATCH_P_ secondary_latch_inst_1 
    (.D(feedback_1), .E(clk_2), .Q(mux_latch_output_1));
    
    _MUX_ mux2to1_inst_1 
    (.Y(mux_output_1), .A(mux_latch_output_1), .B(D), .S(E));
    
    assign mux_output_2 = mux_output_1;
    
    _DLATCH_P_ main_latch_inst_1 
    (.D(mux_output_2), .E(clk_1), .Q(feedback_1));
    
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .E(clk_1), .Q(latched_en));
    
    assign latched_rst = 1'b1;
    
    _DLATCH_P_ secondary_latch_inst_2 
    (.D(feedback_2), .E(clk_1), .Q(mux_latch_output_2));
    
    _MUX_ mux2to1_inst_2 
    (.Y(mux_output_3), .A(mux_latch_output_2), .B(feedback_1), .S(latched_en));
    
    assign mux_output_4 = mux_output_3;
    
    _DLATCH_P_ main_latch_inst_2
    (.D(mux_output_4), .E(clk_2), .Q(feedback_2));
    
    assign Q = feedback_2;

`elsif _DFFE_PP0P_
    _DLATCH_P_ secondary_latch_inst_1 
    (.D(feedback_1), .E(clk_2), .Q(mux_latch_output_1));
    
    _MUX_ mux2to1_inst_1 
    (.Y(mux_output_1), .A(mux_latch_output_1), .B(D), .S(E));
    
    assign mux_output_2 = mux_output_1;
    
    _DLATCH_PN0_ main_latch_inst_2 
    (.D(mux_output_2), .E(clk_2), .R(~R), .Q(feedback_1));
    
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .E(clk_1), .Q(latched_en));
    
    _DLATCH_P_ reset_latch_inst 
    (.D(R), .E(clk_1), .Q(latched_rst));
    
    _DLATCH_P_ secondary_latch_inst_2 
    (.D(feedback_2), .E(clk_1), .Q(mux_latch_output_2));
    
    _MUX_ mux2to1_inst_2 
    (.Y(mux_output_3), .A(mux_latch_output_2), .B(feedback_1), .S(latched_en));
    
    assign mux_output_4 = mux_output_3;
    
    _DLATCH_PN0_ main_latch_inst_3
    (.D(mux_output_4), .E(clk_2), .R(~latched_rst), .Q(feedback_2));
    
    assign Q = feedback_2;

`elsif _SDFFE_PP0P_
    _DLATCH_P_ secondary_latch_inst_1 
    (.D(feedback_1), .E(clk_2), .Q(mux_latch_output_1));
    
    _MUX_ mux2to1_inst_1 
    (.Y(mux_output_1), .A(mux_latch_output_1), .B(D), .S(E));
    
    _MUX_ mux2to1_inst_rst_1 
    (.Y(mux_output_2), .A(mux_output_1), .B(1'b0), .S(R));
    
    _DLATCH_P_ main_latch_inst_2 
    (.D(mux_output_2), .E(clk_2), .Q(feedback_1));
    
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .E(clk_1), .Q(latched_en));
    
    _DLATCH_P_ reset_latch_inst 
    (.D(R), .E(clk_1), .Q(latched_rst));
    
    _DLATCH_P_ secondary_latch_inst_2 
    (.D(feedback_2), .E(clk_1), .Q(mux_latch_output_2));
    
    _MUX_ mux2to1_inst_2 
    (.Y(mux_output_3), .A(mux_latch_output_2), .B(feedback_1), .S(latched_en));
    
    _MUX_ mux2to1_inst_rst_2 
    (.Y(mux_output_4), .A(mux_output_3), .B(1'b0), .S(latched_rst));
    
    _DLATCH_P_ main_latch_inst_3
    (.D(mux_output_4), .E(clk_2), .Q(feedback_2));
    
    assign Q = feedback_2;

`elsif _SDFFE_PN0P_
    _DLATCH_P_ secondary_latch_inst_1 
    (.D(feedback_1), .E(clk_2), .Q(mux_latch_output_1));
    
    _MUX_ mux2to1_inst_1 
    (.Y(mux_output_1), .A(mux_latch_output_1), .B(D), .S(E));
    
    _MUX_ mux2to1_inst_rst_1 
    (.Y(mux_output_2), .A(1'b0), .B(mux_output_1), .S(R));
    
    _DLATCH_P_ main_latch_inst_2 
    (.D(mux_output_2), .E(clk_1), .Q(feedback_1));
    
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .E(clk_1), .Q(latched_en));
    
    _DLATCH_P_ reset_latch_inst 
    (.D(R), .E(clk_1), .Q(latched_rst));
    
    _DLATCH_P_ secondary_latch_inst_2 
    (.D(feedback_2), .E(clk_1), .Q(mux_latch_output_2));
    
    _MUX_ mux2to1_inst_2 
    (.Y(mux_output_3), .A(mux_latch_output_2), .B(feedback_1), .S(latched_en));
    
    _MUX_ mux2to1_inst_rst_2 
    (.Y(mux_output_4), .A(1'b0), .B(mux_output_3), .S(latched_rst));
    
    _DLATCH_P_ main_latch_inst_3
    (.D(mux_output_4), .E(clk_2), .Q(feedback_2));
    
    assign Q = feedback_2;

`elsif _SDFF_PP0_
    _MUX_ mux2to1_inst_1
    (.A(D), .B(1'b0), .S(R), .Y(mux_output_1));
    
    _DLATCH_P_ main_latch_inst_1 
    (.E(clk_1), .D(mux_output_1), .Q(mux_latch_output));
    
    _DLATCH_P_ rst_latch 
    (.E(clk_1), .D(R), .Q(latched_rst));
    
    _MUX_ mux2to1_inst_2
    (.A(mux_latch_output), .B(1'b0), .S(latched_rst), .Y(mux_output_2));
    
    _DLATCH_P_ main_latch_inst_2 
    (.E(clk_2), .D(mux_output_2), .Q(Q));

`elsif _SDFF_PP1_
    _MUX_ mux2to1_inst_1
    (.A(D), .B(1'b1), .S(R), .Y(mux_output_1));
    
    _DLATCH_P_ main_latch_inst_1 
    (.E(clk_1), .D(mux_output_1), .Q(mux_latch_output));
    
    _DLATCH_P_ rst_latch 
    (.E(clk_1), .D(R), .Q(latched_rst));
    
    _MUX_ mux2to1_inst_2
    (.A(mux_latch_output), .B(1'b1), .S(latched_rst), .Y(mux_output_2));
    
    _DLATCH_P_ main_latch_inst_2 
    (.E(clk_2), .D(mux_output_2), .Q(Q));

`elsif _DFF_PP0_
    _DLATCH_PN0_ main_latch_inst_1 
    (.D(D), .E(clk_1), .R(~R), .Q(feedback_1));
    
    _DLATCH_P_ rst_latch 
    (.E(clk_1), .D(R), .Q(latched_rst));
    
    _DLATCH_PN0_ main_latch_inst_2 
    (.D(feedback_1), .E(clk_2), .R(~latched_rst), .Q(Q));

`elsif _SDFF_PN0_
    _MUX_ mux2to1_inst_1
    (.A(1'b0), .B(D), .S(R), .Y(mux_output_1));
    
    _DLATCH_P_ main_latch_inst_1 
    (.E(clk_1), .D(mux_output_1), .Q(mux_latch_output));
    
    _DLATCH_P_ rst_latch 
    (.E(clk_1), .D(R), .Q(latched_rst));
    
    _MUX_ mux2to1_inst_2
    (.A(1'b0), .B(mux_latch_output), .S(latched_rst), .Y(mux_output_2));
    
    _DLATCH_P_ main_latch_inst_2 
    (.E(clk_2), .D(mux_output_2), .Q(Q));

`elsif _SDFF_PN1_
    _MUX_ mux2to1_inst_1
    (.A(1'b0), .B(D), .S(R), .Y(mux_output_1));
    
    _DLATCH_P_ main_latch_inst_1 
    (.E(clk_1), .D(mux_output_1), .Q(mux_latch_output));
    
    _DLATCH_P_ rst_latch 
    (.E(clk_1), .D(R), .Q(latched_rst));
    
    _MUX_ mux2to1_inst_2
    (.A(1'b1), .B(mux_latch_output), .S(latched_rst), .Y(mux_output_2));
    
    _DLATCH_P_ main_latch_inst_2 
    (.E(clk_2), .D(mux_output_2), .Q(Q));

`elsif _DFF_N_
    _DLATCH_P_ secondary_latch 
    (.D(D), .E(clk_2), .Q(feedback_1));
    
    _DLATCH_P_ main_latch 
    (.D(feedback_1), .E(clk_1), .Q(Q));

`elsif _DFF_PN1_ // TODO -------------------------------
    _MUX_ mux2to1_inst_1
    (.Y(mux_output_1), .A(Q), .B(D), .S(R));

    _DLATCH_P_ main_latch_inst_1 
    (.E(clk_1), .D(mux_output_1), .Q(mux_latch_output));

    _DLATCH_P_ rst_latch 
    (.E(clk_1), .D(R), .Q(latched_rst));

    _MUX_ mux2to1_inst_2
    (.Y(mux_output_2), .A(Q), .B(mux_latch_output), .S(latched_rst));

    _DLATCH_P_ main_latch_inst_2 
    (.E(clk_2), .D(mux_output_2), .Q(feedback_1));

    _MUX_ async_rst_mux
    (.Y(Q), .A(1'b1), .B(feedback_1), .S(R));

`elsif _DFF_NN0_
    _DLATCH_P_ latched_rst_inst 
    (.D(R), .Q(latched_rst), .E(clk_1));
    
    _DLATCH_PN0_ secondary_latch 
    (.D(D), .E(clk_2), .R(R), .Q(latch_output));
    
    _DLATCH_PN0_ main_latch 
    (.D(latch_output), .E(clk_1), .R(latched_rst), .Q(Q));

`elsif _DFFE_PN0P_
    _DLATCH_P_ enable_latch_inst 
    (.D(E), .E(clk_1), .Q(latched_en));
    
    _DLATCH_P_ reset_latch_inst 
    (.D(R), .E(clk_1), .Q(latched_rst));

    _DLATCH_PN0_ secondary_latch_inst_1 
    (.D(feedback_1), .E(clk_2), .R(latched_rst), .Q(mux_latch_output_1));
    
    _MUX_ mux2to1_inst_1 
    (.Y(mux_output_1), .A(mux_latch_output_1), .B(D), .S(E));
    
    _DLATCH_PN0_ main_latch_inst_2 
    (.D(mux_output_1), .E(clk_1), .R(R), .Q(feedback_1));
    
    _DLATCH_PN0_ secondary_latch_inst_2 
    (.D(feedback_2), .E(clk_1), .R(R), .Q(mux_latch_output_2));
    
    _MUX_ mux2to1_inst_2 
    (.Y(mux_output_2), .A(mux_latch_output_2), .B(feedback_1), .S(latched_en));
    
    _DLATCH_PN0_ main_latch_inst_3
    (.D(mux_output_2), .E(clk_2), .R(latched_rst), .Q(feedback_2));
    
    assign Q = feedback_2;

`else
    assign mux_output_1 = D;
    
    _DLATCH_P_ main_latch_inst_1 
    (.E(clk_1), .D(mux_output_1), .Q(mux_latch_output));
    
    assign latched_rst = 1'b0;
    
    assign mux_output_2 = mux_latch_output;
    
    _DLATCH_P_ main_latch_inst_2 
    (.E(clk_2), .D(mux_output_2), .Q(Q));
`endif

endmodule
