`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:56:22 09/16/2007 
// Design Name: 
// Module Name:    sub2 
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
module sub2(clk, reset, a_1_1, a_2_1, b_1_1, b_2_1, 
				x_in, y_out);
input clk;
input reset;
input [15:0] a_1_1;
input [15:0] a_2_1;
input [15:0] b_1_1;
input [15:0] b_2_1;
input [15:0] x_in;
output [15:0] y_out;

reg [47:0] x_temp;
reg [47:0] y_temp;
// 声明中间变量，用于格形计算
wire [31:0] x_t;
wire [31:0] y_t;

always @(posedge clk) begin
	if(!reset) begin
	   x_temp <= 0;
		y_temp <= 0;
	end
	else begin
	   x_temp[47:0] <= {x_temp[31:0], x_in}; 
		//截取输出变量的高16位
		y_temp[47:0] <= {y_temp[31:0], x_t[31:16]};
	end
end

assign x_t = reset ? x_temp[47:32]*a_2_1 + x_temp[31:16]*a_1_1 + x_temp[15:0] : 0; 
assign y_t = reset ? y_temp[47:32]*b_2_1 + y_temp[31:16]*b_1_1 + y_temp[15:0] : 0;

assign y_out[15:0] = y_t[31:16]; 

endmodule
