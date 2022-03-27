`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:08:06 09/11/2007 
// Design Name: 
// Module Name:    dds1 
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
module dds1(DATA, WE, A, CLK, SINE, COSINE);
	input [27 : 0] DATA;
	input WE;
	input [4 : 0] A;
	input CLK;
	output [9 : 0] SINE;
	output [9 : 0] COSINE;
	
	mydds mydds1(
   .DATA(DATA),
   .WE(WE),
   .A(A),
   .CLK(CLK),
   .SINE(SINE),
   .COSINE(COSINE)
   );

endmodule
