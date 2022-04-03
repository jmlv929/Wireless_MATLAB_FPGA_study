//~ `New testbench
`timescale  1ns / 1ps

module tb_cordic_iterate;

// cordic_iterate Parameters
parameter PERIOD  = 10     ;
parameter k14     = 16468  ;

// cordic_iterate Inputs
reg   clk                                  = 0 ;    
reg   aresetn                              = 0 ;    
reg   signed[21:0] phase_pre               = 0 ;    
reg   [1:0]  quadrant_flag                 = 0 ;    

// cordic_iterate Outputs
wire  [1:0]  quadrant                      ;        
wire  [23:0]  cos_pre                      ;        
wire  [23:0]  sin_pre                      ;        


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) aresetn  =  1;
end

cordic_iterate #(
    .k14    ( k14    ))
 u_cordic_iterate (
    .clk                     ( clk
          ),
    .aresetn                 ( aresetn
          ),
    .phase_pre  ( phase_pre         ),
    .quadrant_flag           ( quadrant_flag        
   [1:0]  ),

    .quadrant                ( quadrant
   [1:0]  ),
    .cos_pre                 ( cos_pre
   [23:0] ),
    .sin_pre                 ( sin_pre
   [23:0] )
);

initial
begin

    #(PERIOD*13.6);
    phase_pre = 28_0000;
    quadrant_flag = 2'b00;

    #(PERIOD*30); //14

    $finish;
end

endmodule