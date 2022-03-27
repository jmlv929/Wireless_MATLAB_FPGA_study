`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:16:06 09/23/2007 
// Design Name: 
// Module Name:    filter_bank 
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
module filter_bank(clk, reset, x_in, y_out1, y_out2);
input clk;
input reset;
input [15:0] x_in;
output [15:0] y_out1;
output [15:0] y_out2;

wire [15:0] coe1 = 5138;
wire [15:0] coe2 = 28718;
wire [15:0] y1, y2;

//调用格形滤波单元的子模块
trellis_unit trellis_unit1(
    .clk(clk), .reset(reset), .coe(coe1), 
	 .x_in1(x_in), .x_in2(x_in), .y_out1(y1), .y_out2(y2));
	 
trellis_unit trellis_unit2(
    .clk(clk), .reset(reset), .coe(coe1), 
	 .x_in1(y1), .x_in2(y2), .y_out1(y_out1), .y_out2(y_out2));

endmodule
