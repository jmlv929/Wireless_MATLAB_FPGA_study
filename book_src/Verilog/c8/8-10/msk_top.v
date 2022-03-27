`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:13:24 10/05/2007 
// Design Name: 
// Module Name:    msk_top 
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
module msk_top(clk_100MHz, clk_2MHz, clk_1MHz, reset, x, msk_out);
input clk_100MHz;
input clk_2MHz;
input clk_1MHz;
input reset;
input x;
output [32:0] msk_out;

wire b_i, b_q;
wire [15:0] sine, cosine;

//调用基带数据处理模块
s2p s2p(
  .clk(clk_2MHz), .clk_div2(clk_1MHz), .reset(reset), 
  .x(x), .b_i(b_i), .b_q(b_q));

//调用IQ路加权模块iqsin.v
iqsin iqsin(
  .clk(clk_100MHz), .reset(reset), .b_i(b_i), .b_q(b_q), 
  .SINE(sine), .COSINE(cosine));

//载波调制相加模块iqmodu.v
iqmodu iqmodu(
  .clk(clk_100MHz), .i_i(cosine), .q_q(sine), .msk_out(msk_out));
  
endmodule
