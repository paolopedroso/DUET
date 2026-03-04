`timescale 1ns/1ps 

// from OpenROAD-flow-scripts/tools/OpenROAD/test/sky130hd/work_around_yosys/formal_pdk.v
module sky130_fd_sc_hd__mux2i_1 (X,A0,A1,S);
output X;
reg X;
input A0;
input A1;
input S;
always @* casez ({A0,A1,S})
  3'b00?: {X} = 1'b0;
  3'b11?: {X} = 1'b1;
  3'b0?0: {X} = 1'b0;
  3'b1?0: {X} = 1'b1;
  3'b?01: {X} = 1'b0;
  3'b?11: {X} = 1'b1;
endcase;
endmodule
