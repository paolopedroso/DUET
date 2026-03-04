`timescale 1ns/1ps
// From https://github.com/YosysHQ/yosys/blob/main/techlibs/common/simcells.v:
// "A negative edge D-type flip-flop."
module _DFF_N_ (D, C, Q);
input D, C;
output reg Q;
always @(negedge C) begin
	Q <= D;
end
endmodule
