`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:18:35 09/23/2007 
// Design Name: 
// Module Name:    trellis_unit 
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
module trellis_unit(clk, reset, coe, x_in1, x_in2, y_out1, y_out2);
input clk; 
input reset;
input [15:0] coe;
input [15:0] x_in1;
input [15:0] x_in2;
output [15:0] y_out1, y_out2;

reg [15:0] x_t2;
always @(posedge clk) begin
   if(!reset) 
	   x_t2 <= 0;
	else //作一级寄存
	   x_t2[15:0] <=  x_in2; 
end

//完成格形运算
assign y_out1 = x_t2[15:0] - x_in1[15:0]*coe[15:0];
assign y_out2 = x_in1[15:0] + x_t2[15:0]*coe[15:0];

endmodule
