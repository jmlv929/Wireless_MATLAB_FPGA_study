module divider_gen (
    input aclk,
    input s_axis_dividend_tvalid,
    input[7 : 0] s_axis_divisor_tdata,
    input s_axis_divisor_tvalid,
    input[7 : 0] s_axis_dividend_tdata,
    output[7:0] quotient,
    output[5:0] remainder,
    output m_axis_dout_tvalid
);

wire[15:0] m_axis_dout_tdata;
div_gen_0 your_instance_name (
  .aclk(aclk),                                      // input wire aclk
  .s_axis_divisor_tvalid(s_axis_divisor_tvalid),    // input wire s_axis_divisor_tvalid
  .s_axis_divisor_tdata(s_axis_divisor_tdata),      // input wire [7 : 0] s_axis_divisor_tdata
  .s_axis_dividend_tvalid(s_axis_dividend_tvalid),  // input wire s_axis_dividend_tvalid
  .s_axis_dividend_tdata(s_axis_dividend_tdata),    // input wire [7 : 0] s_axis_dividend_tdata
  .m_axis_dout_tvalid(m_axis_dout_tvalid),          // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(m_axis_dout_tdata)            // output wire [15 : 0] m_axis_dout_tdata
);

assign quotient = m_axis_dout_tdata[15:8];
assign remainder = m_axis_dout_tdata[5:0];

endmodule

