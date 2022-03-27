`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:00:27 10/08/2007 
// Design Name: 
// Module Name:    adder8_4 
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
module adder8_4(cout ,sum ,clk ,cina ,cinb ,cin);
input [7 :0]cina ,cinb;
input clk ,cin;
output [7 :0] sum;
output cout;
reg cout ;
reg cout1, cout2, cout3;
reg [2 :0]sum1;
reg [4:0] sum2;
reg [6:0] sum3;
reg [7 :0]sum;

always @(posedge clk) begin // 低二位相加
{cout1 ,sum1} = cina [ 1 :0 ] + cinb [ 1 :0 ] + cin;
end

always @(posedge clk) begin  //相加,并且将低4 位拼接起来;
{cout2 ,sum2} = {{cina[3],cina[3 :2 ]} + {cinb[3],cinb[3 :2 ]} + cout1 ,sum1};
end

always @(posedge clk) begin //相加,并且将低六位拼接起来;
{cout3 , sum3} = {{cina[5],cina [ 5 : 4 ]} + {cinb[5],cinb [ 5 : 4 ]} + cout2 ,sum2};
end

always @(posedge clk) begin //高2位相加,并且将8位拼接起来;
{cout ,sum} = {{cina[7],cina [7 :6 ]} + {cinb[7],cinb[7 :6 ]} + cout3 ,sum3};
end

endmodule

