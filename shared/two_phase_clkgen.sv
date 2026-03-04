`timescale 1ns/1ps

// this clock generator reflect on two phase .sdc constraints

module two_phase_clkgen 
    #(parameter real period_p = 20.0,
      parameter real duty_cycle_p = 0.49)
    (output reg clk_1,
     output reg clk_2);

    real high_time;
    real dead_time;
    
    initial begin
        high_time = period_p * duty_cycle_p;
        dead_time = (period_p / 2.0) - high_time;
        
        if (duty_cycle_p >= 0.5) begin
            $error("duty_cycle_p must be less than 0.5 for non-overlapping clocks");
            $finish;
        end
        
        if (dead_time <= 0) begin
            $error("dead_time is %f, must be positive", dead_time);
            $finish;
        end
        
        // $display("clk gen: period_p=%f, duty_cycle_p=%f", period_p, duty_cycle_p);
        // $display("  high_time=%f, dead_time=%f", high_time, dead_time);
    end
    
    initial begin
        clk_1 = 0;
        clk_2 = 0;
        
        forever begin
            clk_1 = 1;
            #high_time;
            clk_1 = 0;
            
            #dead_time;

            clk_2 = 1;
            #high_time;
            clk_2 = 0;
            
            #dead_time;
        end
    end

endmodule
