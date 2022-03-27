`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:21:56 09/19/2007 
// Design Name: 
// Module Name:    sender_modu 
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
module sender_modu(clk_30p72MHz, reset, x_in, cosine, y_out);
input clk_30p72MHz;
input reset;
input [15:0] x_in;
input [15:0] cosine;
output [31:0] y_out;

send_mult send_mult(
  .clk(clk_30p72MHz), 
  .a(x_in), 
  .b(cosine), 
  .q(y_out),
  .ce(reset)
);

endmodule
