`timescale 1ns/1ps
// From https://github.com/YosysHQ/yosys/blob/main/techlibs/common/simcells.v:
// "A negative enable D-type latch."
module _DLATCH_P_ (E, D, Q);
input E, D;
output reg Q;
`ifdef SIMCELL
always @* begin
	if (E == 1)
		Q <= D;
end
`elsif SKY130HD
sky130_fd_sc_hd__dlxtp_1 dlatch_inst (.Q(Q),.D(D),.GATE(E));
`elsif ASAP7
DHLx1_ASAP7_75t_R dlatch_inst (.D(D),.CLK(E),.Q(Q));
`else
$error("Not implemented.")
`endif
endmodule
module _DLATCH_P__p #(parameter WIDTH=1) (
  output reg [WIDTH-1:0] Q
  ,input [WIDTH-1:0] D
  ,input E
);
genvar i;
generate
  for(i=0;i<WIDTH;i++) begin : latch_array
    _DLATCH_P_ latch_array_inst (
      .Q(Q[i])
      ,.D(D[i])
      ,.E(E)
    );
  end
endgenerate
endmodule
