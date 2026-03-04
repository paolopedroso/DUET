`timescale 1ns/1ps
// From https://github.com/YosysHQ/yosys/blob/main/techlibs/common/simcells.v:
// "A positive edge D-type flip-flop with negative polarity reset and positive
// polarity clock enable.""
module _DFFE_PN0P_ (D, C, R, E, Q);
input D, C, R, E;
output reg Q;
always @(posedge C or negedge R) begin
	if (R == 0)
		Q <= 0;
	else if (E == 1)
		Q <= D;
end
endmodule
