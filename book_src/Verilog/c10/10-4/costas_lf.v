`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:55:39 08/09/2007 
// Design Name: 
// Module Name:    costas_lf 
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
module costas_lf(clk, reset, a, q);
input clk;
input reset;
input [15:0] a;
output [15:0] q;

reg [15:0] a1_t;
reg [31:0] a2_t;

always @(posedge clk) begin
	if(!reset) begin
	   a1_t <= 10000;
		a2_t <= 0;
	end
	else begin
		a2_t[31:16] <= a2_t[15:0] + a;  
	end
end

assign q = a1_t + a2_t[31:16];

endmodule
