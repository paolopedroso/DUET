`timescale 1ns/1ps
// From https://github.com/YosysHQ/yosys/blob/main/techlibs/common/simcells.v:
// A positive edge D-type flip-flop with positive polarity synchronous set and positive
// polarity clock enable (with clock enable having priority).
module _SDFFCE_PP1P_ (D, C, R, E, Q);
input D, C, R, E;
output reg Q;
always @(posedge C) begin
	if (E == 1) begin
		if (R == 1)
			Q <= 1;
		else
			Q <= D;
	end
end
endmodule
