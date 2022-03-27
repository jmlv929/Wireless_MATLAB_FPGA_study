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
input [15:0] coeff; //可配置滤波器的系数通道
input [15:0] x_in;
output [31:0] y_out;

//声明子模块之间的连接信号
wire [15:0] rcf_out, fir_out, cic2_out, cic4_out;
wire [9:0] cosine;

//调用系数可配置的滤波器子程序
rcf16 rcf16(
      .clk_3p84MHz(clk_3p84MHz), 
		.clk_61p44MHz(clk_61p44MHz), 
		.reset(reset),
		.we(we), 
		.x_in(x_in), 
		.coeff(coeff), 
		.y_out(rcf_out));
		
//调用系数固定的FIR低通滤波器子程序
fir16 fir16(
      .clk_30p72MHz(clk_30p72MHz), 
		.reset(reset), 
		.x_in(rcf_out), 
		.y_out(fir_out));
		
//调用CIC2倍插值滤波器
cic2_interp cic2_interp(
      .clk_3p84MHz(clk_3p84MHz), 
		.clk_7p68MHz(clk_7p68MHz), 
		.reset(reset), 
		.x(fir_out), 
		.y(cic2_out));
		
//调用CIC4倍插值滤波器
cic4_interp4 cic4_interp4(
      .clk_30p72MHz(clk_30p72MHz), 
		.clk_7p68MHz(clk_7p68MHz), 
		.reset(reset), 
		.x(cic2_out), 
		.y(cic4_out));
		
//调用DDS模块，产生15MHz的载波 
mydds mydds(
      .CLK_30p72MHz(clk_30p72MHz), 
		.CE(reset), 
		.COSINE(cosine));

//对信号完成载波调制	
sender_modu sender_modu(
      .clk_30p72MHz(clk_30p72MHz), 
		.reset(reset), 
		.x_in(cic4_out), 
		//扩展位宽
		.cosine({{5{cosine[9]}},cosine[9:0]}), 
		.y_out(y_out));
		
endmodule
