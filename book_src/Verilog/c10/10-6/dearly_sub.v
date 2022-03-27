`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:16:14 09/23/2007 
// Design Name: 
// Module Name:    dearly_sub 
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
module dearly_sub(clk4, reset, x_in, s_d, s_e);
input clk4; //clk4的频率为数据速率的4倍
input reset;
input [15:0] x_in;
output [15:0] s_d, s_e;

reg [15:0] s_d, s_e;
reg [1:0] cnt;

//假设cnt=1为当前时刻,则cnt=0为早采样，cnt=1为迟采样
always @(posedge clk4) begin
   if(!reset) begin
	   s_d <= 0;
		s_e <= 0;
		cnt <= 0;
	end
	else begin
		cnt <= cnt + 1;
		case(cnt)
		   2'b00: begin //早采样
			   s_e <= x_in;
				s_d <= s_d;
			end
			2'b10: begin //迟采样
			   s_e <= s_e;
				s_d <= x_in;			
			end
			default: begin
			   s_e <= s_e;
				s_d <= s_d;			
			end
		endcase
	end
end

endmodule
