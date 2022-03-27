`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:13:53 10/05/2007 
// Design Name: 
// Module Name:    iqsin 
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
module iqsin(clk, reset, b_i, b_q, SINE, COSINE);
input b_i, b_q;
input clk, reset;
output [15:0] SINE, COSINE;

wire [27:0] DATA1, DATA2;
wire [4:0] A = (!reset)? 0 : 5'b10000;
wire we = 1'b1;
dds1_sine sin_msk(
   .DATA(DATA1), .WE(we), .A(A), .CLK(clk),
   .SINE(SINE));
dds1_cosine cosine_msk(
   .DATA(DATA2), .WE(we), .A(A), .CLK(clk),
   .COSINE(COSINE));
	
assign DATA1 = (!reset) ? 2684354 : b_i ? 134217728 : 0;
assign DATA2 = (!reset) ? 2684354 : b_q ? 134217728 : 0;

endmodule
