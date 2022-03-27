`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:41:20 10/02/2007 
// Design Name: 
// Module Name:    rake_mrc 
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
module rake_mrc(clk, reset, x1_r, x1_i, x2_r, x2_i, x3_r, x3_i,
                c1_r, c1_i, c2_r, c2_i, c3_r, c3_i, y_r, y_i);
input clk;   //数据时钟
input reset; //模块复位信号
input [15:0] x1_r, x1_i, x2_r, x2_i, x3_r, x3_i;//各支路输入信号
input [15:0] c1_r, c1_i, c2_r, c2_i, c3_r, c3_i;//各支路相位纠正信号
output [15:0] y_r, y_i; // Rake接收机输出信号
 
//调用复数乘法器，完成输入变量自身的平方运算
wire [15:0] xt1_r, xt1_i, xt2_r, xt2_i, xt3_r, xt3_i;
rake_cmult rake_cmult_01(
	.ar(x1_r), .ai(x1_i), .br(x1_r), .bi(x1_i),
	.pr(xt1_r), .pi(xt1_i), .clk(clk), .ce(reset));
rake_cmult rake_cmult_02(
	.ar(x2_r), .ai(x2_i), .br(x2_r), .bi(x2_i),
	.pr(xt2_r), .pi(xt2_i), .clk(clk), .ce(reset));
rake_cmult rake_cmult_03(
	.ar(x3_r), .ai(x3_i), .br(x3_r), .bi(x3_i),
	.pr(xt3_r), .pi(xt3_i), .clk(clk), .ce(reset));

//由于复数乘法需要4个时钟周期，所以相位校正变量需要寄存4个时钟周期
wire [15:0] c1_rt, c1_it, c2_rt, c2_it, c3_rt, c3_it;
rake_shift4 rake_shift4_01 (
   .clk(clk), .d(c1_r), .q(c1_rt));
rake_shift4 rake_shift4_02 (
   .clk(clk), .d(c1_i), .q(c1_it));
rake_shift4 rake_shift4_03 (
   .clk(clk), .d(c2_r), .q(c2_rt));
rake_shift4 rake_shift4_04 (
   .clk(clk), .d(c2_i), .q(c2_it));
rake_shift4 rake_shift4_05 (
   .clk(clk), .d(c3_r), .q(c3_rt));
rake_shift4 rake_shift4_06 (
   .clk(clk), .d(c3_i), .q(c3_it));

//完成相位纠正，输出同相信号
wire [15:0] f1_rt, f1_it, f2_rt, f2_it, f3_rt, f3_it;
rake_cmult rake_cmult_04(
	.ar(xt1_r), .ai(xt1_i), .br(c1_rt), .bi(c1_it),
	.pr(f1_rt), .pi(f1_it), .clk(clk), .ce(reset));
rake_cmult rake_cmult_05(
	.ar(xt2_r), .ai(xt2_i), .br(c2_rt), .bi(c2_it),
	.pr(f2_rt), .pi(f2_it), .clk(clk), .ce(reset));
rake_cmult rake_cmult_06(
	.ar(xt3_r), .ai(xt3_i), .br(c3_rt), .bi(c3_it),
	.pr(f3_rt), .pi(f3_it), .clk(clk), .ce(reset));

//累加同相信号, 输出Rake接收机信号
assign y_r = f1_rt +  f2_rt +  f3_rt;
assign y_i = f1_it +  f2_it +  f3_it;

endmodule
