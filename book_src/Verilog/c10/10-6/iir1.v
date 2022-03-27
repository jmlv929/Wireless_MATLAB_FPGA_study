`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:49:50 09/24/2007 
// Design Name: 
// Module Name:    iir1 
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
module iir1(clk, reset, x_in, y_out);
input clk;
input reset;
input [15:0] x_in;
output [15:0] y_out;

reg [31:0] x_t, y_t;
wire [15:0] x_out, b4, b6, q4, q5, q6;

assign b4 = 19071;
assign b6 = 16381;

always @(posedge clk) begin
   if(!reset) begin
	   x_t <= 0;
		y_t <= 0;
	end
	else begin
	   x_t[31:0] <= {x_t[15:0], x_in};
		y_t[31:0] <= {y_t[15:0], x_out};
	end
end

assign x_out = q4 + q5 + q6;
assign y_out = x_out;

de_mult de_mult4(
  .clk(clk), .a(x_t[15:0]), .b(b4), .q(q4));

de_mult de_mult5(
  .clk(clk), .a(x_t[31:16]), .b(b4), .q(q5));

de_mult de_mult6(
  .clk(clk), .a(y_t[31:16]), .b(b6), .q(q6));
  
endmodule
