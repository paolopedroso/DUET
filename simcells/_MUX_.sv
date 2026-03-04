`timescale 1ns/1ps
// From https://github.com/YosysHQ/yosys/blob/main/techlibs/common/simcells.v:
// "A 2-input MUX gate."
module _MUX_ (A, B, S, Y);
input A, B, S;
output Y;
`ifdef SIMCELL
assign Y = S ? B : A;
`elsif SKY130HD
sky130_fd_sc_hd__udp_mux_2to1 mux_2to1_inst (.X(Y), .A0(A), .A1(B), .S(S));
`elsif ASAP7
`else
$error("Not implemented.")
`endif
endmodule
module _MUX__p #(parameter WIDTH = 1) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input S,
    output [WIDTH-1:0] Y
);
genvar i;
generate
  for(i = 0; i < WIDTH; i = i + 1) begin : mux_array
    _MUX_ mux_array_inst (
      .Y(Y[i]),
      .A(A[i]),
      .B(B[i]),
      .S(S)
    );
  end
endgenerate
endmodule
