`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:44:13 09/23/2007 
// Design Name: 
// Module Name:    iir 
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
module iir(clk, reset, x_in, y_out);
input clk;
input reset;
input [15:0] x_in;
output [15:0] y_out;

reg [31:0] x_t, y_t;
wire [15:0] x_out, b1, b3, q1, q2, q3;
assign b1= 6603;
assign b3 = 31834;

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

assign x_out = q1 + q2 + q3;
assign y_out = x_out;

de_mult de_mult1(
  .clk(clk), .a(x_t[15:0]), .b(b1), .q(q1));

de_mult de_mult2(
  .clk(clk), .a(x_t[31:16]), .b(b1), .q(q2));

de_mult de_mult3(
  .clk(clk), .a(y_t[31:16]), .b(b3), .q(q3));

endmodule
