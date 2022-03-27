`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:31:38 09/23/2007 
// Design Name: 
// Module Name:    delay_early_gate 
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
//////////////////////////////////////////////////////////////////////////////
module Delay_Early_Gate(clk4, clk, reset, x_in, clk_7p68MHz);
input clk4; //��Ƶ�����������ʵ�4��
input clk;  //��������
input reset; 
input [15:0] x_in; //��������
output clk_7p68MHz;//�����Żָ�������ͬ��ʱ��

wire [15:0] s_d, s_e;
wire [15:0] iir_d, iir_e, iir_sub, iir1_out;

//�����Ų���������
dearly_sub dearly_sub(
   .clk4(clk4), .reset(reset), .x_in(x_in), .s_d(s_d), .s_e(s_e));

//�Բ������ݽ��е�ͨ�˲�
iir iir_d1(
   .clk(clk), .reset(reset), .x_in(s_d), .y_out(iir_d));
iir iir_e1(
   .clk(clk), .reset(reset), .x_in(s_e), .y_out(iir_e));	

//������������ݵ���������������ݵ����
assign iir_sub = reset ? (iir_d - iir_e) : 0;

//�Գ����Ų����ݽ���խ���˲�
iir1 iir1(
   .clk(clk), .reset(reset), .x_in(iir_sub), .y_out(iir1_out));

//����DDS���
dedds dedds(
   .clk(clk), .reset(reset), .data(iir1_out), .clk_7p68MHz(clk_7p68MHz)); 

endmodule

