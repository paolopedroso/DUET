`timescale 1ns/1ps
// From https://github.com/YosysHQ/yosys/blob/main/techlibs/common/simcells.v:
// "A positive edge D-type flip-flop with positive polarity synchronous set."
module _SDFF_PP1_ (D, C, R, Q);
input D, C, R;
output reg Q;
always @(posedge C) begin
	if (R == 1)
		Q <= 1;
	else
		Q <= D;
end
endmodule
