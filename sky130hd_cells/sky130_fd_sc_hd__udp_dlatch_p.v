`timescale 1ns/1ps

// from OpenROAD-flow-scripts/tools/OpenROAD/test/sky130hd/work_around_yosys/formal_pdk.v
module sky130_fd_sc_hd__udp_dlatch$P_p #(parameter WIDTH=1)(
  output reg [WIDTH-1:0] Q
  ,input [WIDTH-1:0] D
  ,input GATE
);
genvar i;
generate
  for(i=0;i<WIDTH;i++) begin : latch_array
    sky130_fd_sc_hd__udp_dlatch$P latch_inst (
      .Q(Q[i])
      ,.D(D[i])
      ,.GATE(GATE)
    );
  end
endgenerate
endmodule
