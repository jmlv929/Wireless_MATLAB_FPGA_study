`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:28:52 09/21/2007 
// Design Name: 
// Module Name:    dds 
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
module dds(data, we, clk, ce, reset, sine, cose);

input [31 : 0] data;  //Ƶ�ʿ�����
input we;  //Ƶ�ʿ�����дʹ��
input clk;  //ʱ��
input ce;  //DDSʹ��
input reset;  //��λ
output [15 : 0] sine;  //�����ź����
output [15 : 0] cose;  //�����ź����

reg [31 : 0] ADD_A;  //���Ҳ�����ģ�����λ�ۼ���
reg [31 : 0] ADD_B;  //���Ҳ�����ģ�����λ�ۼ���
reg [15 : 0] cose_DR;  //���Ҳ��Ĳ��ұ��ַ
reg [15 : 0] sine_DR;  //
wire [31 : 0] data;  //Ƶ�ʿ�����
wire [9 : 0] ROM_A;
wire [15 : 0] cose_D;
wire [15 : 0] sine_D;

assign cose = cose_DR;
assign sine = sine_DR;
assign ROM_A = ADD_B[31 : 22];

always @ (posedge clk or posedge reset)
begin
   if(reset)  //ϵͳ��ʼ��ʱ,Ĭ�ϵ�Ƶ�ʿ�����Ϊ0
      ADD_A <= 0;
   else if(we)
      ADD_A <= data;
end

always @ (posedge clk or posedge reset)
begin
   if(reset)
      ADD_B <= 0;
   else if(ce)
      ADD_B <= ADD_B + ADD_A;  //ADD_BΪ�ۼӵĽ��
end

always @ (posedge clk or posedge reset)
begin
   if(reset)
      cose_DR <= 0;
   else if(ce)
      cose_DR <= cose_D;
end

always @ (posedge clk or posedge reset)
begin
   if(reset)
      sine_DR <= 0;
   else if(ce)
      sine_DR <= sine_D;
end

//��������ROM���洢�������Ҳ���һ�����ڵ���ֵ��
rom_cose cose1(
   .addra(ROM_A),
   .clka(clk),
   .douta(cose_D));
	
rom_sine sine1(
   .addra(ROM_A),
   .clka(clk),
   .douta(sine_D));

endmodule  

