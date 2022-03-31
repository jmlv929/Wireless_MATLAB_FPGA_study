//~ `New testbench
`timescale  1ns / 1ps

module tb_Cordic_cos_IP;

// Cordic_cos_IP Parameters
parameter PERIOD  = 10;


// Cordic_cos_IP Inputs
reg   aclk                                 = 0 ;
reg   s_axis_phase_tvalid                  = 0 ;
reg   [15:0]  s_axis_phase_tdata           = 0 ;

// Cordic_cos_IP Outputs
wire  m_axis_dout_tvalid                   ;    
wire  [31:0]  m_axis_dout_tdata            ;    


initial
begin
    forever #(PERIOD/2)  aclk=~aclk;
end

Cordic_cos_IP  u_Cordic_cos_IP (
    .aclk                    ( aclk
           ),
    .s_axis_phase_tvalid     ( s_axis_phase_tvalid         ),
    .s_axis_phase_tdata      ( s_axis_phase_tdata   [15:0] ),

    .m_axis_dout_tvalid      ( m_axis_dout_tvalid          ),
    .m_axis_dout_tdata       ( m_axis_dout_tdata    [31:0] )
);

initial
begin
    s_axis_phase_tvalid = 0;
    s_axis_phase_tdata = 16'b000000_1110011011;  // -pi/4
    #(PERIOD*24.5);

    s_axis_phase_tvalid = 1;
    #(PERIOD*25);  

    s_axis_phase_tdata = 16'b000000_0011001001;  // pi/2
    #(PERIOD*70);

    $finish;
end

endmodule