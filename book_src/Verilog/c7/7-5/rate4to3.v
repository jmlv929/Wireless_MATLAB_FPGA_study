`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:26:36 10/09/2007 
// Design Name: 
// Module Name:    rate4to3 
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
module rate4to3(clk, clk_data, reset, x, y);
input clk;
input clk_data;
input reset; 
input [7:0]x;
output [7:0]y;

reg [7:0] y;
reg [7:0] x_3;
reg [1:0] cnt;

// 3
wire clk_div3;
clkdiv3 clkdiv3(
	.clk(clk_data), 
	.reset(reset), 
	.clk_div3(clk_div3)
);

always @(posedge clk_div3)
	x_3 <= x;

always @(posedge clk) begin
	if(!reset) begin
		cnt <= 2'b00;
		y <= 0;
	end
	else begin
	   cnt <= cnt +1;
		if(cnt <= 2'b00)
		   y <= x_3;
		else
		   y <= 0;
	end	
end

endmodule

