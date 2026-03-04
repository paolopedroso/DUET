`timescale 1ns/1ps

// from OpenROAD-flow-scripts/tools/OpenROAD/test/sky130hd/work_around_yosys/formal_pdk.v
module sky130_fd_sc_hd__dlclkp (GCLK,GATE,CLK);


    
    output GCLK;
    input  GATE;
    input  CLK ;

    
    wire m0  ;
    wire clkn;

    
    not                           not0    (clkn  , CLK            );
    sky130_fd_sc_hd__udp_dlatch$P dlatch0 (m0    , GATE, clkn     );
    and                           and0    (GCLK  , m0, CLK        );


endmodule
