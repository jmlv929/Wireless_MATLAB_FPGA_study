//~ `New testbench
`timescale  1ns / 1ps

module tb_multiply_signed;

// multiply Parameters
parameter PERIOD  = 10;


// multiply Inputs
reg   clk                                  = 0 ;
reg   CE                                   = 0 ;
reg   SCLR                                 = 0 ;
reg   [15:0]  A                            = 0 ;
reg   [15:0]  B                            = 0 ;
reg   [3:0]  C                             = 0 ;
reg   SUBTRACT                             = 0 ;

// multiply Outputs
wire[47:0]  P                                    ;
wire[47:0]  PCOUT                                ;


initial
begin
    forever #(PERIOD/2)  clk = ~clk;
end

initial
begin
    #(PERIOD*10) SCLR  =  0;
end

multiply_signed  u_multiply (
    .clk                     ( clk              ),
    .CE                      ( CE               ),
    .SCLR                    ( SCLR             ),
    .A                       ( A         [15:0] ),
    .B                       ( B         [15:0] ),
    .C                       ( C         [3:0]  ),
    .SUBTRACT                ( SUBTRACT         ),

    .P                       ( P                ),
    .PCOUT                   ( PCOUT            )
);

initial
begin
    SUBTRACT = 0; 
    A = -8;    //A    2'complemrntary saved
    B = 37;
    C = -6;

    # (PERIOD*20) 

    CE = 1;
    #(PERIOD*20) 

    B = 9;
    #(PERIOD*10)

    A = 2;
    #(PERIOD*10)

    $finish;
end

endmodule