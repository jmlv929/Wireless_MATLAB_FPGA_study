`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:53:25 08/30/2007 
// Design Name: 
// Module Name:    gonge 
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
module gonge(clk, reset, x_i, x_q, y_i, y_q);
input clk;
input reset;
input [15:0] x_i;
input [15:0] x_q;
output [15:0] y_i;
output [15:0] y_q;

reg [15:0] x_i_t, x_q_t;
always @(posedge clk) begin
	if(!reset) begin
	   x_i_t <= 0;
		x_q_t <= 0;
	end
	else begin
	   x_i_t <= x_i;
		if(x_q[15] == 0)
		  x_q_t <= ~x_q + 1;
		else
		  x_q_t <= ~(x_q - 1); 
	end
end


assign y_i = (!reset) ? 0 : x_i_t;
assign y_q = (!reset) ? 0 : x_q_t;

endmodule
