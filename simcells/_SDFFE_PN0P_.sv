`timescale 1ns/1ps
// From https://github.com/YosysHQ/yosys/blob/main/techlibs/common/simcells.v:
// "A positive edge D-type flip-flop with negative polarity synchronous reset and positive"
// "polarity clock enable (with reset having priority)."
module _SDFFE_PN0P_ (D, C, R, E, Q);
input D, C, R, E;
output reg Q;
always @(posedge C) begin
	if (R == 0)
		Q <= 0;
	else if (E == 1)
		Q <= D;
end
endmodule
module _SDFFE_PN0P__p #(parameter WIDTH=1)(
  output reg [WIDTH-1:0] Q
  ,input [WIDTH-1:0] D
  ,input E
  ,input R
  ,input C
);
genvar i;
generate
  for(i=0;i<WIDTH;i++)begin : flop_array
    _SDFFE_PN0P_ _DFFE_PP__inst (
      .D(D[i])
      ,.C(C)
      ,.E(E)
      ,.R(R)
      ,.Q(Q[i])
    );
  end
endgenerate
endmodule
