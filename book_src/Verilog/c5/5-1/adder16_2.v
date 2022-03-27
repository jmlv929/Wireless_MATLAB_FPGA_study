`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:01:57 10/08/2007 
// Design Name: 
// Module Name:    adder16_2 
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
module adder16_2(cout ,sum ,clk ,cina ,cinb ,cin) ;
input [15 :0 ]cina ,cinb ;
input clk ,cin ;
output [15 :0 ] sum;
output cout ;
reg cout ;
reg cout1 ;
reg[7 :0 ] sum1 ;
reg[15 :0 ] sum;

always @(posedge clk) begin  // 低8 位相加;
{cout1 , sum1} = {cina [7], cina [ 7 : 0 ]} +  {cinb[7], cinb [ 7 : 0 ]} +cin ;
end

always @(posedge clk) begin  // 高8 位相加，并连成16位
{cout ,sum} = {{cina [15], cina [15 :8 ] }+ {cinb [15], cinb[15 :8]} + cout1 , sum1} ; 
end

endmodule

