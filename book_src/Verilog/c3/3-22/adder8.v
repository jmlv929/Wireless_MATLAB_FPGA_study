`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:57:44 10/08/2007 
// Design Name: 
// Module Name:    adder8 
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
module adder8 (cout ,sum ,clk ,cina ,cinb ,cin);
input [7 :0 ]cina ,cinb;
input clk ,cin;
output [7 :0 ] sum;
output cout;

reg[7 :0 ]sum;
reg cout ;

always @(posedge clk)　begin // 时钟上升沿有效;
{cout ,sum} = cina + cinb + cin ; // 8 位相加;
end

endmodule

