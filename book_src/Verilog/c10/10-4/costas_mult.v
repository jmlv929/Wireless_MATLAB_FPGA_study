`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:55:40 08/07/2007 
// Design Name: 
// Module Name:    costas_mult 
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
module costas_mult(clk, reset, s_in, v_1, v_2, v_3, v_4);
input clk;
input reset;
input [15:0] s_in;
input [15:0] v_1;
input [15:0] v_2;
output [15:0] v_3;
output [15:0] v_4;

wire [31:0] q1, q2;
// 实例化乘法器的IPcore，其中输入为16比特，输出为32比特。	 
mult mult01(  
  .ce(reset),   //时钟信号
  .clk(clk),  //乘法器工作时钟
  .a(s_in),        //两个输
  .b(v_1), 
  .q(q1)         //输出信号
);

mult mult02(  
  .ce(reset),   //时钟信号
  .clk(clk),  //乘法器工作时钟
  .a(s_in),        //两个输
  .b(v_2), 
  .q(q2)         //输出信号
);

// 进行截位，直接取16位
assign v_3 = q1[31:16];
assign v_4 = q2[31:16];

endmodule
