`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:50:44 09/09/2007 
// Design Name: 
// Module Name:    adder1 
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
module adder1(add1_in_a,  add1_in_b, c_in,  add1,  add1_out,  clk);
input [25:0] add1_in_a, add1_in_b;
input c_in, add1, clk;
output [25:0] add1_out;


adder adder26(
	.A(add1_in_a),
	.B(add1_in_b),
	.C_IN(c_in),
	.ADD(add1),
	.Q(add1_out),
	.CLK(clk)
	);	
	
endmodule

