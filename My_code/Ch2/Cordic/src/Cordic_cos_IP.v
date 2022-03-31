
module Cordic_cos_IP(
    input aclk,
    input s_axis_phase_tvalid,
    input [15:0] s_axis_phase_tdata,  //输入有效数据为10位 其他位不重要
    output m_axis_dout_tvalid,
    output[31:0] m_axis_dout_tdata  //x低位 y高位 
    //x 和 y在IP核设置过程中为10位 数据格式见Xilinx文档

);

cordic_0 cordic_inst0(
  .aclk(aclk),                                // input wire aclk
  .s_axis_phase_tvalid(s_axis_phase_tvalid),  // input wire s_axis_phase_tvalid
  .s_axis_phase_tdata(s_axis_phase_tdata),    // input wire [15 : 0] s_axis_phase_tdata
  .m_axis_dout_tvalid(m_axis_dout_tvalid),    // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(m_axis_dout_tdata)      // output wire [31 : 0] m_axis_dout_tdata
);

endmodule