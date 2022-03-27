`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:02:53 10/08/2007 
// Design Name: 
// Module Name:    adder_4 
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
module add_4 (x, y, sum, C);
input [3:0] x, y;
output [3:0] sum;
output C;
assign {C, Sum} = x + y;
endmodule

