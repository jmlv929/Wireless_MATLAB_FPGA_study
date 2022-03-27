`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:47:48 09/19/2007 
// Design Name: 
// Module Name:    mydds 
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
module mydds( CLK_30p72MHz, CE, COSINE);
   input CLK_30p72MHz;
   input CE;
   output [9 : 0] COSINE;
	
	wire [26 : 0] DATA;
   wire WE;
   wire [4 : 0] A;
	
	//配置生成10MHz输出的DDS模块
	assign DATA = 1253655;
	assign A = 0;
	assign WE = CE;
	
	//配置生成10MHz输出的DDS模块 
	dds dds1(
   .CLK(CLK_30p72MHz),
   .CE(CE),
   .COSINE(COSINE),
	.DATA(DATA),
   .WE(WE),
   .A(A));
	
endmodule
