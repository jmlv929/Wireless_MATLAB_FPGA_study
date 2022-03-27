`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:56:38 09/16/2007 
// Design Name: 
// Module Name:    iir_c 
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
module iir_c(clk, reset, x_in, y_out);
input clk;
input reset;
input [15:0] x_in;
output [15:0] y_out;

wire [15:0] y1_out;
wire [15:0] a1_1_1, a1_2_1, b1_1_1, b1_2_1; //IIRÂË²¨Æ÷µÄÏµÊý
wire [15:0] a2_1_1, a2_2_1, b2_1_1, b2_2_1;

assign a1_1_1 =  36504;
assign a1_2_1 =  -23396;
assign b1_1_1 =  0;
assign b1_2_1 =  32768;
assign a2_1_1 =  0;
assign a2_2_1 =  58832;
assign b2_1_1 =  32768;
assign b2_2_1 =  36054;

sub2 sub2_1(.clk(clk), .reset(reset), 
            .a_1_1(a1_1_1), .a_2_1(a1_2_1), 
				.b_1_1(b1_1_1), .b_2_1(b1_2_1), 
				.x_in(x_in), .y_out(y1_out));

sub2 sub2_2(.clk(clk), .reset(reset), 
            .a_1_1(a2_1_1), .a_2_1(a2_2_1), 
				.b_1_1(b2_1_1), .b_2_1(b2_2_1), 
				.x_in(y1_out), .y_out(y_out));

endmodule

