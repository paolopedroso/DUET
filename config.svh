`ifndef CONFIG_SVH
`define CONFIG_SVH

`define NUM_TESTS 150

`define IS_DFFE_PP0P   0
`define IS_SDFFE_PP0P  0
`define IS_SDFFE_PN0P  0
`define IS_SDFF_PP0    0
`define IS_DFFE_PP     0
`define IS_SDFF_PP1    0
`define IS_SDFF_PN1    0
`define IS_DFF_PP0     0
`define IS_SDFF_PN0    0
`define IS_DFF_N       0
`define IS_DFF_PN1     0
`define IS_DFF_NN0     0
`define IS_SDFFCE_PN0P 0
`define IS_DFFE_PN0P   0
`define IS_DFFE_PN1P   0

`ifdef _DFFE_PP0P_
  `undef IS_DFFE_PP0P
  `define IS_DFFE_PP0P 1
`elsif _SDFFE_PP0P_
  `undef IS_SDFFE_PP0P
  `define IS_SDFFE_PP0P 1
`elsif _SDFFE_PN0P_
  `undef IS_SDFFE_PN0P
  `define IS_SDFFE_PN0P 1
`elsif _SDFF_PP0_
  `undef IS_SDFF_PP0
  `define IS_SDFF_PP0 1
`elsif _DFFE_PP_
  `undef IS_DFFE_PP
  `define IS_DFFE_PP 1
`elsif _SDFF_PP1_
  `undef IS_SDFF_PP1
  `define IS_SDFF_PP1 1
`elsif _SDFF_PN1_
  `undef IS_SDFF_PN1
  `define IS_SDFF_PN1 1
`elsif _DFF_PP0_
  `undef IS_DFF_PP0
  `define IS_DFF_PP0 1
`elsif _SDFF_PN0_
  `undef IS_SDFF_PN0
  `define IS_SDFF_PN0 1
`elsif _DFF_N_
  `undef IS_DFF_N
  `define IS_DFF_N 1


// TODO: to be added in the library
`elsif _DFF_PN1_
  `undef IS_DFF_PN1
  `define IS_DFF_PN1 1
`elsif _DFF_NN0_
  `undef IS_DFF_NN0
  `define IS_DFF_NN0 1
`elsif _SDFFCE_PN0P_
  `undef IS_SDFFCE_PN0P
  `define IS_SDFFCE_PN0P 1
`elsif _DFFE_PN0P_
  `undef IS_DFFE_PN0P
  `define IS_DFFE_PN0P 1
`elsif _DFFE_PN1P_
  `undef IS_DFFE_PN1P
  `define IS_DFFE_PN1P 1
`endif

`endif