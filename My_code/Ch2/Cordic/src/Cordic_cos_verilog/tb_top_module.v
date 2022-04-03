//~ `New testbench
`timescale  1ns / 1ps

module tb_top_module;

// top_module Parameters
parameter PERIOD  = 10     ;
parameter x_init  = 10_0000;

// top_module Inputs
reg   clk                                  = 0 ;
reg   aresetn                              = 0 ;
reg   [21:0]  phase                        = 0 ;

// top_module Outputs
wire  signed[23:0] cos                     ;  
wire  signed[23:0] sin                     ;  


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) aresetn  =  1;
end

top_module #(
    .x_init ( x_init ))
 u_top_module (
    .clk                     ( clk
          ),
    .aresetn                 ( aresetn        
          ),
    .phase                   ( phase
   [21:0] ),

    .cos        ( cos         ),
    .sin        ( sin         )
);

initial
begin

    #(PERIOD*14.7);

    phase = 30_0000;  //第一象限 30deg  cos = 0.8660  sin = 0.5000

    #(PERIOD*30);

    phase = 110_0000;  //第二象限 110deg  -0.3420  0.9397
    #(PERIOD*30);

    phase = -136_0000;  //第三象限 -100deg  -0.7193    -0.6947
    #(PERIOD*30);

    phase = -40_0000;  //第四象限 -40deg   0.7660   -0.6428
    #(PERIOD*30);

    $finish;
end

endmodule