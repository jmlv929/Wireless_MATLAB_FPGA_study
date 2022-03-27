`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:59:33 10/08/2007 
// Design Name: 
// Module Name:    adder8_2 
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
module adder8_2(cout ,sum ,clk ,cina ,cinb ,cin) ;
input [7 :0]cina ,cinb;
input clk ,cin;
output [7 :0] sum;
output cout;
reg cout ;
reg cout1 ;
reg[3 :0]sum1;
reg[7 :0]sum;

always @(posedge clk) begin //第4 位相加;
{cout1 , sum1} = cina [3 : 0] + cinb [3 : 0] + cin ; 
end
always @(posedge clk) begin  //高4 位相加,并且将8 位拼接起来;
{cout ,sum} = {{cina[7],cina [7 :4]} +{cinb[7], cinb[7 :4] + cout1} ,sum1};
end

endmodule

