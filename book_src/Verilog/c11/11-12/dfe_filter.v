`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:54:26 10/02/2007 
// Design Name: 
// Module Name:    dfe_filter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module dfe_filter(clk, reset, x_in, y_out);
input clk;   //数据速率
input reset; //复位信号
input [15:0] x_in; //输入数据
output y_out; //输出数据,1表示“-1”，0表示“1”

//用于正向、反馈之路滤波器的缓存
reg [31:0] x_t, f_t; 
wire [15:0] y_t;
//正向、反馈滤波器的系数
reg [15:0] ccoe1, ccoe2, bcoe1, bcoe2;
wire [15:0] s_yt, s_x1, s_x2;
wire [15:0] f_f1, f_f2;
//正向、反馈滤波器的输出
wire [15:0] y_i, f_i;

//完成滤波数据的移位
always @(posedge clk) begin
   if(!reset) begin
	   x_t <= 0;
		f_t <= 0;
		ccoe1 <= 0;
		ccoe2 <= 0;
		bcoe1 <= 0;
		bcoe2 <= 0;
	end
	else begin
	   x_t[31:0] <= {x_t[15:0], x_in};
		f_t[31:0] <= {f_t[15:0], y_t};
		ccoe1 <= ccoe1 - {{4{s_x1[15]}}, s_x1[15:4]};
		ccoe2 <= ccoe2 - {{4{s_x2[15]}}, s_x2[15:4]};
		bcoe1 <= bcoe1 - {{4{f_f1[15]}}, f_f1[15:4]};
		bcoe2 <= bcoe2 - {{4{f_f2[15]}}, f_f2[15:4]};		
	end
end

//完成正向通路的滤波
wire [15:0] m_out1, m_out2;
dfe_mult dfe_mult_01(
  .clk(clk), .a(x_t[15:0]), .b(ccoe1), .q(m_out1));
dfe_mult dfe_mult_02(
  .clk(clk), .a(x_t[31:16]), .b(ccoe2), .q(m_out2));
assign y_i = m_out1 + m_out2;

//完成反馈支路的滤波
wire [15:0] m_out3, m_out4;
dfe_mult dfe_mult_03(
  .clk(clk), .a(f_t[15:0]), .b(bcoe1), .q(m_out3));
dfe_mult dfe_mult_04(
  .clk(clk), .a(f_t[31:16]), .b(bcoe2), .q(m_out4));
assign f_i = m_out3 + m_out4;

//完成前向、反馈滤波器输出相减以及判决输出
wire [15:0] s_i;
assign s_i = y_i - f_i;
// 这里采用硬判决，将数据判决到正最大和负最大
assign y_t = s_i[15] ? 16'b1000_0000_0000_0000 
            : 16'b0111_1111_1111_1111;
assign y_out = y_t[15];

//正向通路的系数更新模块
assign s_yt = s_i - y_t;
dfe_mult dfe_mult_05(
  .clk(clk), .a(s_yt), .b(x_t[15:0]), .q(s_x1));
dfe_mult dfe_mult_06(
  .clk(clk), .a(s_yt), .b(x_t[31:16]), .q(s_x2));
  
//反馈通路的系数更新模块
dfe_mult dfe_mult_07(
  .clk(clk), .a(s_yt), .b(f_t[15:0]), .q(f_f1));
dfe_mult dfe_mult_08(
  .clk(clk), .a(s_yt), .b(f_t[31:16]), .q(f_f2));
  
endmodule
