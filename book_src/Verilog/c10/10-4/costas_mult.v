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
// ʵ�����˷�����IPcore����������Ϊ16���أ����Ϊ32���ء�	 
mult mult01(  
  .ce(reset),   //ʱ���ź�
  .clk(clk),  //�˷�������ʱ��
  .a(s_in),        //������
  .b(v_1), 
  .q(q1)         //����ź�
);

mult mult02(  
  .ce(reset),   //ʱ���ź�
  .clk(clk),  //�˷�������ʱ��
  .a(s_in),        //������
  .b(v_2), 
  .q(q2)         //����ź�
);

// ���н�λ��ֱ��ȡ16λ
assign v_3 = q1[31:16];
assign v_4 = q2[31:16];

endmodule
