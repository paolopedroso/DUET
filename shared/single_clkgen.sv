`timescale 1ns/1ps

module single_clkgen
    #(parameter real period_p = 20.0)
    (output reg default_clk);
    initial begin
        assert(period_p >= 2) else
        $error("Error, cannot simulate cycle time less than 2"); 
        default_clk = 0;
        forever #(period_p/2) default_clk = ~default_clk;
    end
endmodule
