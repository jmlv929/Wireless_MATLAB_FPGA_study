//~ `New testbench
`timescale  1ns / 1ps

module tb_cordic_pre;

// cordic_pre Parameters
parameter PERIOD          = 10          ;
parameter quadrant_first  = 2'b00       ;
parameter angle_90        = 22'sd90_0000;

// cordic_pre Inputs
reg   clk                                  = 0 ;      
reg   aresetn                              = 0 ;      
reg   [21:0]  phase                        = 0 ;      

// cordic_pre Outputs
wire  [1:0] quadrant_flag               ;
wire  [21:0]  phase_pre                    ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) aresetn  =  1;
end

cordic_pre #(
    .quadrant_first ( quadrant_first ),
    .angle_90       ( angle_90       ))
 u_cordic_pre (
    .clk                     ( clk
        ),
    .aresetn                 ( aresetn
        ),
    .phase                   ( phase
 [21:0] ),

    . quadrant_flag  (quadrant_flag 
        ),
    .phase_pre               ( phase_pre
 [21:0] )
);

initial
begin

    #(PERIOD*8.7);

    phase = 45_0000; 
    #(PERIOD*2);

    phase = 120_0000;
    #(PERIOD*2);

    phase = -110_0000;
    #(PERIOD*2);

    phase = -30_0000;
    #(PERIOD*8);
    $finish;
end

endmodule