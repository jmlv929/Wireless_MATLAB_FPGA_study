`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:55:52 09/12/2007 
// Design Name: 
// Module Name:    div16_1 
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
module div16_1 (clk, dividend, divisor, quotient, remainder, rfd);

input clk;
input [15 : 0] dividend;
input [15 : 0] divisor;
output [15 : 0] quotient;
output [15 : 0] remainder;
output rfd;

div16 div16_1(.clk(clk), .dividend(dividend), .divisor (divisor), .quotient (quotient), 
.remainder(remainder), .rfd(rfd));

endmodule
