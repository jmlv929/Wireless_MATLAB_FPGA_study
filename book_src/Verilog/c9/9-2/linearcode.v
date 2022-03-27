`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:41:40 08/12/2007 
// Design Name: 
// Module Name:    linearcode 
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
module linearcode(reset, u, c);
input reset;
input [3:0] u;
output [6:0] c;

assign c[3:0] = reset ? 4'b000 : u[3:0];
assign c[4] = reset ? 0 :(u[0] ^ u[2] ^ u[3]);
assign c[5] = reset ? 0 :(u[0] ^ u[1] ^ u[2]);
assign c[6] = reset ? 0 :(u[1] ^ u[2] ^ u[3]); 

endmodule
