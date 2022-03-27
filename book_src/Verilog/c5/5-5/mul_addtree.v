`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:48:19 10/08/2007 
// Design Name: 
// Module Name:    mul_addertree 
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
module mul_addtree(mul_a, mul_b, mul_out, clk, rst_n);
parameter MUL_WIDTH = 4;
parameter MUL_RESULT = 8;

input [MUL_WIDTH-1 : 0] mul_a;
input [MUL_WIDTH-1 : 0] mul_b;
input clk;
input rst_n;
output [MUL_RESULT-1 : 0] mul_out;
reg [MUL_RESULT-1 : 0] mul_out;
reg [MUL_RESULT-1 : 0] stored0;
reg [MUL_RESULT-1 : 0] stored1;
reg [MUL_RESULT-1 : 0] stored2;
reg [MUL_RESULT-1 : 0] stored3;
reg [MUL_RESULT-1 : 0] add01;
reg [MUL_RESULT-1 : 0] add23;

always @ (posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin  //初始化寄存器变量
         mul_out <= 8'b0000_0000;
         stored0 <= 8'b0000_0000;
         stored1 <= 8'b0000_0000;
         stored2 <= 8'b0000_0000;
         stored3 <= 8'b0000_0000;
         add01 <= 8'b0000_0000;
         add23 <= 8'b0000_0000;
      end
   else
      begin  //实现移位相加
         stored3 <= mul_b[3]?{1'b0,mul_a,3'b0}: 8'b0;
         stored2 <= mul_b[2]?{2'b0,mul_a,2'b0}: 8'b0;
         stored1 <= mul_b[1]?{3'b0,mul_a,1'b0}: 8'b0;
         stored0 <= mul_b[0]?{4'b0,mul_a}: 8'b0;
         add01 <= stored1 + stored0;
         add23 <= stored3 + stored2;
         mul_out <= add01 + add23;
      end
end

endmodule

