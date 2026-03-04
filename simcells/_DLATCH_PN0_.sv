`timescale 1ns/1ps
// From https://github.com/YosysHQ/yosys/blob/main/techlibs/common/simcells.v:
// "A positive enable D-type latch with negative polarity reset."
module _DLATCH_PN0_ (E, R, D, Q);
input E, R, D;
output reg Q;
`ifdef SIMCELL
always @* begin
	if (R == 0)
                Q <= 0;
	else if (E == 1)
		Q <= D;
end
`elsif SKY130HD
sky130_fd_sc_hd__dlrtp_1 dlrtp_inst (.GATE(E),.RESET_B(R),.D(D),.Q(Q));
`elsif ASAP7
`else
$error("Not implemented.");
`endif
endmodule
module _DLATCH_PN0__p #(parameter WIDTH=1) (
  output reg [WIDTH-1:0] Q
  ,input [WIDTH-1:0] D
  ,input R
  ,input E
);
genvar i;
generate
  for(i=0;i<WIDTH;i++) begin : latch_array
    _DLATCH_PN0_ latch_array_inst (
      .Q(Q[i])
      ,.D(D[i])
      ,.R(R)
      ,.E(E)
    );
  end
endgenerate
endmodule
