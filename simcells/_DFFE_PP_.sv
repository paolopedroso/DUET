`timescale 1ns/1ps
// From https://github.com/YosysHQ/yosys/blob/main/techlibs/common/simcells.v:
// "A positive edge D-type flip-flop with positive polarity enable."
module _DFFE_PP_(D, C, E, Q);
input D, C, E;
output reg Q;
always @(posedge C) begin
	if (E) Q <= D;
end
endmodule
module _DFFE_PP__p #(parameter WIDTH=1)(
  output reg [WIDTH-1:0] Q
  ,input [WIDTH-1:0] D
  ,input E
  ,input C
);
genvar i;
generate
  for(i=0;i<WIDTH;i++)begin : flop_array
    _DFFE_PP_ _DFFE_PP__inst (
      .D(D[i])
      ,.C(C)
      ,.E(E)
      ,.Q(Q[i])
    );
  end
endgenerate
endmodule
