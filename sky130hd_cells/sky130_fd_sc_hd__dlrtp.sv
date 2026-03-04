`timescale 1ns/1ps 

// from OpenROAD-flow-scripts/tools/OpenROAD/test/sky130hd/work_around_yosys/formal_pdk.v
module sky130_fd_sc_hd__dlrtp (Q,RESET_B,D,GATE);


    
    output Q      ;
    input  RESET_B;
    input  D      ;
    input  GATE   ;

    
    wire RESET;
    wire buf_Q;

    
    not                                        not0    (RESET , RESET_B        );
    sky130_fd_sc_hd__udp_dlatch$PR  dlatch0 (buf_Q , D, GATE, RESET );
    buf                                        buf0    (Q     , buf_Q          );


endmodule
