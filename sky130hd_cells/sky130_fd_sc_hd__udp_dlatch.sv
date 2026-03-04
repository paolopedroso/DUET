`timescale 1ns/1ps

// from OpenROAD-flow-scripts/tools/OpenROAD/test/sky130hd/work_around_yosys/formal_pdk.v
module sky130_fd_sc_hd__udp_dlatch$P (Q,D,GATE);
output Q;
input D;
input GATE;
reg Q;
always @(GATE or D)
  if (GATE) Q <= D;
endmodule
module sky130_fd_sc_hd__udp_dlatch$PR (Q,D,GATE,RESET);
output Q;
input D;
input GATE;
input RESET;
reg Q;
wire AG = GATE | RESET;
wire AD = (~RESET) & D;
always @(AG or AD)
  if (AG) Q <= AD;
endmodule
