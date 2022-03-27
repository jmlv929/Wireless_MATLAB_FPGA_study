`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:49:57 10/08/2007 
// Design Name: 
// Module Name:    mult_8 
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
module mult_8 (x,y,p);
input  [7:0] x;
input  [7:0] y;
output [7:0] p;
assign p=x*y;
endmodule

