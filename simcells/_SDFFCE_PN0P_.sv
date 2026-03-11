`timescale 1ns/1ps
// From https://github.com/YosysHQ/yosys/blob/main/techlibs/common/simcells.v:
// "A positive edge D-type flip-flop with negative polarity synchronous reset and positive
// polarity clock enable (with clock enable having priority)."
module _SDFFCE_PN0P_ (D, C, R, E, Q);
input D, C, R, E;
output reg Q;
always @(posedge C) begin
	if (E == 1) begin
		if (R == 0)
			Q <= 0;
		else
			Q <= D;
	end
end
endmodule
