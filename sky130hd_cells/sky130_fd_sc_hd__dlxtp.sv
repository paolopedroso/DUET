`timescale 1ns/1ps

// from OpenROAD-flow-scripts/tools/OpenROAD/test/sky130hd/work_around_yosys/formal_pdk.v
module sky130_fd_sc_hd__dlxtp (Q,D,GATE);


    
    output Q   ;
    input  D   ;
    input  GATE;

    
    wire buf_Q;

    
    sky130_fd_sc_hd__udp_dlatch$P dlatch0 (buf_Q , D, GATE        );
    buf                           buf0    (Q     , buf_Q          );


endmodule
