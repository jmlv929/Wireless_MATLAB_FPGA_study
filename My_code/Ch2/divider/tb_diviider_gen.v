`timescale  1ns / 1ps

module tb_divider_gen;

// divider_gen Parameters
parameter PERIOD  = 10;


// divider_gen Inputs
reg   aclk                                 = 0 ;
reg   s_axis_dividend_tvalid               = 0 ;
reg[7 : 0]   s_axis_divisor_tdata                 = 0 ;
reg   s_axis_divisor_tvalid                = 0 ;
reg[7 : 0]   s_axis_dividend_tdata                = 0 ;

// divider_gen Outputs
wire[7 : 0]   quotient                    ;
wire[5:0] remainder;
wire  m_axis_dout_tvalid                   ;


initial
begin
    forever #(PERIOD/2)  aclk=~aclk;
end

divider_gen  u_divider_gen (
    .aclk                    ( aclk                     ),
    .s_axis_dividend_tvalid  ( s_axis_dividend_tvalid   ),
    .s_axis_divisor_tdata    ( s_axis_divisor_tdata     ),
    .s_axis_divisor_tvalid   ( s_axis_divisor_tvalid    ),
    .s_axis_dividend_tdata   ( s_axis_dividend_tdata    ),

    .quotient       ( quotient        ),
    .remainder (remainder),
    .m_axis_dout_tvalid      ( m_axis_dout_tvalid       )
);

initial
begin
    s_axis_dividend_tvalid = 0;
    s_axis_divisor_tdata  = 7;
    s_axis_divisor_tvalid  = 0;
    s_axis_dividend_tdata  =-53;
    # (PERIOD*50.5);

    s_axis_dividend_tvalid = 1;
    #(PERIOD*30);

    s_axis_divisor_tvalid  = 1;
    #(PERIOD*30);

    s_axis_dividend_tdata  =29;
    s_axis_divisor_tdata  = -6;
    #(PERIOD*30);

    $finish;
end

endmodule