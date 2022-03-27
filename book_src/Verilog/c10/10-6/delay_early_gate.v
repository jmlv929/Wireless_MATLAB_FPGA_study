`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:31:38 09/23/2007 
// Design Name: 
// Module Name:    delay_early_gate 
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
//////////////////////////////////////////////////////////////////////////////
module Delay_Early_Gate(clk4, clk, reset, x_in, clk_7p68MHz);
input clk4; //其频率是数据速率的4倍
input clk;  //数据速率
input reset; 
input [15:0] x_in; //输入数据
output clk_7p68MHz;//迟早门恢复出来的同步时钟

wire [15:0] s_d, s_e;
wire [15:0] iir_d, iir_e, iir_sub, iir1_out;

//迟早门采样的数据
dearly_sub dearly_sub(
   .clk4(clk4), .reset(reset), .x_in(x_in), .s_d(s_d), .s_e(s_e));

//对采样数据进行低通滤波
iir iir_d1(
   .clk(clk), .reset(reset), .x_in(s_d), .y_out(iir_d));
iir iir_e1(
   .clk(clk), .reset(reset), .x_in(s_e), .y_out(iir_e));	

//计算迟早门数据的误差计算迟早门数据的误差
assign iir_sub = reset ? (iir_d - iir_e) : 0;

//对迟早门差数据进行窄带滤波
iir1 iir1(
   .clk(clk), .reset(reset), .x_in(iir_sub), .y_out(iir1_out));

//控制DDS输出
dedds dedds(
   .clk(clk), .reset(reset), .data(iir1_out), .clk_7p68MHz(clk_7p68MHz)); 

endmodule

