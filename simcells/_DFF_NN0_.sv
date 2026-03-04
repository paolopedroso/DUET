`timescale 1ns/1ps
// From https://github.com/YosysHQ/yosys/blob/main/techlibs/common/simcells.v:
// "A negative edge D-type flip-flop with negative polarity reset."
module _DFF_NN0_ (D, C, R, Q);
input D, C, R;
output reg Q;
always @(negedge C or negedge R) begin
	if (R == 0)
		Q <= 0;
	else
		Q <= D;
end
endmodule
