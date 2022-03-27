`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:25:38 09/12/2007 
// Design Name: 
// Module Name:    sqrt1 
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
module sqrt1(x_in, clk, ce, sclr, x_out); 
input [31 : 0] x_in;
input clk, ce, sclr;
output [16 : 0] x_out;
  
  sqrt sqrt(.x_in(x_in), .clk(clk), .ce(ce), .sclr(sclr), .x_out(x_out));

endmodule

