`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:44:16 09/22/2007 
// Design Name: 
// Module Name:    cic2_interp 
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
module cic2_interp(clk_3p84MHz, clk_7p68MHz, reset, x, y);
		input clk_7p68MHz;            // 模块工作时钟
		input clk_3p84MHz;           // 其数值为clk的一半
		input reset;
		input [15:0] x;
		output [15:0] y;

		reg [31:0] x_t, y_t;  // 用于移位的寄存器
		reg [15:0] int_out, temp; //中间变量


		always@(posedge clk_3p84MHz) begin
		   if(!reset) begin //给寄存器赋初值
				x_t <= 0;
			   int_out <= 0;
			end
			else begin
				x_t <= {x_t[15:0], x};
				int_out <= x_t[15:0] + x_t[31:16];
			end

		end

		always@(posedge clk_7p68MHz) begin
			if(!reset) begin
				y_t <= 0;
				temp <= 0;
			end
			else begin
				if(clk_3p84MHz == 1)  //完成插值
					temp <= 0;
				else 
					temp <= int_out;
				y_t <= {y_t[15:0], temp};
			end
		end
		
		assign y = y_t[15:0] - y_t[31:16];// 完成梳状滤波
		
endmodule
