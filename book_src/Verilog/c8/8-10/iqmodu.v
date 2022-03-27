`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:45:08 10/05/2007 
// Design Name: 
// Module Name:    iqmodu 
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
module iqmodu(clk,i_i, q_q, msk_out);
input clk;
input [15:0] i_i, q_q;
output [32:0] msk_out;

wire [27:0] DATA;
wire [4:0] A;
wire WE;
assign DATA = 13421772;
assign A = 0;
assign WE = 1;
wire [15:0] sine, cosine;
wire [31:0] q1, q2;

//����DDS��IPcore������5MHz���ز�
dds_modu dds_modu(
   .DATA(DATA),.WE(WE),.A(A),
   .CLK(clk),.SINE(sine),.COSINE(cosine));

//�������źź��ز��ź���ˣ����Ƶ�װ���
msk_mult msk_mult01(
  .clk(clk), .a(cosine), .b(i_i), .q(q1));
msk_mult msk_mult02(
  .clk(clk), .a(sine), .b(q_q), .q(q2));

//I��Q·������ӣ�����MSK�ź�
assign msk_out = {q1[31], q1} + {q2[31], q2};

endmodule
