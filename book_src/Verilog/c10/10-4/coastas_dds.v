`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:12:17 08/07/2007 
// Design Name: 
// Module Name:    coastas_dds 
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
module coastas_dds(clk, reset, data, y1, y2);
input clk;
input reset;
input [23:0] data;
output [15:0] y1;
output [15:0] y2;

wire [4:0] add;
assign add = 0;
my_dds mydds(
   .DATA(data),
	.CE(reset),
   .WE(reset),
   .A(add),
   .CLK(clk),
   .SINE(y1),
	.COSINE(y2)
   );
	
endmodule
