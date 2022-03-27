`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:54:05 08/30/2007 
// Design Name: 
// Module Name:    cmult 
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
module cmult(clk, reset, x_i, x_q, c_i, c_q, y_i, y_q);
input clk;
input reset;
input [15:0] x_i;
input [15:0] x_q;
input [15:0] c_i;
input [15:0] c_q;
output [15:0] y_i;
output [15:0] y_q;

wire [15:0] coe_i;
wire [15:0] coe_q;

complex_mult complex_mult01(
	.ar(x_i),
	.ai(x_q),
	.br(coe_i),
	.bi(coe_q),
	.pr(y_i),
	.pi(y_q),
	.clk(clk),
	.ce(reset));
	
// 调用移位寄存器,用来存储系数	
shiftreg shiftreg_i(
   .clk(clk), 
	.d(c_i), 
	.q(coe_i));
	
shiftreg shiftreg_q(
   .clk(clk), 
	.d(c_q), 
	.q(coe_q));

endmodule
