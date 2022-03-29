`timescale  1ns / 1ps

module tb_divider;   

// divider Parameters
parameter PERIOD  = 10;


// divider Inputs
reg   clk                                  = 0 ;
reg   [7:0]  a                             = 0 ;
reg   [7:0]  b                             = 0 ;

// divider Outputs
wire[7:0] q                           ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end


divider  u_divider (
    .clk                     ( clk               ),
    .a                       ( a           [7:0] ),
    .b                       ( b           [7:0] ),

    .q              (  q        )
);

initial
begin

    a = 8;
    b = 4;  // is 2^n
    #(PERIOD*20);

    a = 7;
    b = 3;   // the result is float
    #(PERIOD*20);

    a = -9;
    b = 2; // a is negative
    #(PERIOD*20)

    a = 7;
    b = -2; // a is negative
    #(PERIOD*20)

    $finish;
end

endmodule