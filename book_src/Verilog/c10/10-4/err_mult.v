`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:51:03 08/09/2007 
// Design Name: 
// Module Name:    err_mult 
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
module err_mult(clk, reset, a, b, q);
input clk;
input reset;
input [15:0] a;
input [15:0] b;
output [15:0] q;

wire [31:0] q1; 
mult mult03(  
  .ce(reset),   //ʱ���ź�
  .clk(clk),  //�˷�������ʱ��
  .a(a),        //������
  .b(b), 
  .q(q1)         //����ź�
);

assign q = q1[31:16];

endmodule
