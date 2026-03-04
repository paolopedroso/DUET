
`timescale 1ns/1ps 

// paramaterizable mux array
// from OpenROAD-flow-scripts/tools/OpenROAD/test/sky130hd/work_around_yosys/formal_pdk.v
module sky130_fd_sc_hd__mux2i_1_p #(parameter WIDTH=1)(
  output [WIDTH-1:0] X,
  input [WIDTH-1:0] A0,
  input [WIDTH-1:0] A1,
  input S
);
genvar i;
generate
  for(i=0; i<WIDTH; i++) begin : mux_array
    sky130_fd_sc_hd__mux2i_1 mux_inst (
      .X(X[i]),
      .A0(A0[i]),
      .A1(A1[i]),
      .S(S)
    );
  end
endgenerate
endmodule
