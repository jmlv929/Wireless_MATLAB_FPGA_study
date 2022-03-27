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

input [31 : 0] data;  //频率控制字
input we;  //频率控制字写使能
input clk;  //时钟
input ce;  //DDS使能
input reset;  //复位
output [15 : 0] sine;  //正弦信号输出
output [15 : 0] cose;  //余弦信号输出

reg [31 : 0] ADD_A;  //正弦波产生模块的相位累加器
reg [31 : 0] ADD_B;  //余弦波产生模块的相位累加器
reg [15 : 0] cose_DR;  //余弦波的查找表地址
reg [15 : 0] sine_DR;  //
wire [31 : 0] data;  //频率控制字
wire [9 : 0] ROM_A;
wire [15 : 0] cose_D;
wire [15 : 0] sine_D;

assign cose = cose_DR;
assign sine = sine_DR;
assign ROM_A = ADD_B[31 : 22];

always @ (posedge clk or posedge reset)
begin
   if(reset)  //系统初始化时,默认的频率控制字为0
      ADD_A <= 0;
   else if(we)
      ADD_A <= data;
end

always @ (posedge clk or posedge reset)
begin
   if(reset)
      ADD_B <= 0;
   else if(ce)
      ADD_B <= ADD_B + ADD_A;  //ADD_B为累加的结果
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

//调用两个ROM，存储着正余弦波形一个周期的数值。
rom_cose cose1(
   .addra(ROM_A),
   .clka(clk),
   .douta(cose_D));
	
rom_sine sine1(
   .addra(ROM_A),
   .clka(clk),
   .douta(sine_D));

endmodule  

