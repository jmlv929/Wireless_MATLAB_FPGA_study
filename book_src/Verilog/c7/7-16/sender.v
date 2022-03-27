`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:20:14 09/20/2007 
// Design Name: 
// Module Name:    sender 
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
module sender(clk_61p44MHz, clk_30p72MHz, clk_7p68MHz, clk_3p84MHz,
              reset, we, coeff, x_in, y_out);
input clk_61p44MHz;
input clk_30p72MHz;
input clk_7p68MHz;
input clk_3p84MHz;
input reset;
input we;
input [15:0] coeff; //�������˲�����ϵ��ͨ��
input [15:0] x_in;
output [31:0] y_out;

//������ģ��֮��������ź�
wire [15:0] rcf_out, fir_out, cic2_out, cic4_out;
wire [9:0] cosine;

//����ϵ�������õ��˲����ӳ���
rcf16 rcf16(
      .clk_3p84MHz(clk_3p84MHz), 
		.clk_61p44MHz(clk_61p44MHz), 
		.reset(reset),
		.we(we), 
		.x_in(x_in), 
		.coeff(coeff), 
		.y_out(rcf_out));
		
//����ϵ���̶���FIR��ͨ�˲����ӳ���
fir16 fir16(
      .clk_30p72MHz(clk_30p72MHz), 
		.reset(reset), 
		.x_in(rcf_out), 
		.y_out(fir_out));
		
//����CIC2����ֵ�˲���
cic2_interp cic2_interp(
      .clk_3p84MHz(clk_3p84MHz), 
		.clk_7p68MHz(clk_7p68MHz), 
		.reset(reset), 
		.x(fir_out), 
		.y(cic2_out));
		
//����CIC4����ֵ�˲���
cic4_interp4 cic4_interp4(
      .clk_30p72MHz(clk_30p72MHz), 
		.clk_7p68MHz(clk_7p68MHz), 
		.reset(reset), 
		.x(cic2_out), 
		.y(cic4_out));
		
//����DDSģ�飬����15MHz���ز� 
mydds mydds(
      .CLK_30p72MHz(clk_30p72MHz), 
		.CE(reset), 
		.COSINE(cosine));

//���ź�����ز�����	
sender_modu sender_modu(
      .clk_30p72MHz(clk_30p72MHz), 
		.reset(reset), 
		.x_in(cic4_out), 
		//��չλ��
		.cosine({{5{cosine[9]}},cosine[9:0]}), 
		.y_out(y_out));
		
endmodule
