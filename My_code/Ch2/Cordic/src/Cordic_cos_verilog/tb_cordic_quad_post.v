//~ `New testbench
`timescale  1ns / 1ps

module tb_cordic_quad_post;

// cordic_quad_post Parameters
parameter PERIOD  = 10     ;
parameter x_init  = 10_0000;

// cordic_quad_post Inputs
reg   clk                                  = 0 ;
reg   aresetn                              = 0 ;
reg   [1:0]  quadrant                      = 0 ;
reg   [23:0]  cos_pre                      = 0 ;
reg   [23:0]  sin_pre                      = 0 ;

// cordic_quad_post Outputs
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

cordic_quad_post #(
    .x_init ( x_init ))
 u_cordic_quad_post (
    .clk                     ( clk
          ),
    .aresetn                 ( aresetn        
          ),
    .quadrant                ( quadrant       
   [1:0]  ),
    .cos_pre                 ( cos_pre        
   [23:0] ),
    .sin_pre                 ( sin_pre        
   [23:0] ),

    .cos        ( cos         ),
    .sin        ( sin         )
);

initial
begin

    #(PERIOD*12.8);
    quadrant = 2'b01; //130 deg
    cos_pre = 17150;
    sin_pre = -98520; // becasuse the pre module turn the second theta quadrant into 
    // the fourth quadrant .

    #(PERIOD*5);

    quadrant = 2'b10; //-45 deg
    cos_pre = 70710;
    sin_pre = -70710; 
    #(PERIOD*5);

    $finish;
end

endmodule