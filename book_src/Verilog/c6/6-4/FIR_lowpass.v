`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:37:08 10/09/2007 
// Design Name: 
// Module Name:    FIR_lowpass 
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
module FIR_Lowpass(Data_out,Data_in,clock,reset);//8阶高斯低通FIR

parameter order = 8;
parameter word_size_in = 8;
parameter word_size_out = 2*word_size_in + 1;

//滤波器系数
parameter b0 = 8'd7;  
parameter b1 = 8'd17; 
parameter b2 = 8'd32; 
parameter b3 = 8'd46; 
parameter b4 = 8'd52; 
parameter b5 = 8'd46; 
parameter b6 = 8'd32; 
parameter b7 = 8'd17; 
parameter b8 = 8'd7; 

output [word_size_out-1 : 0] Data_out;
input [word_size_in-1 : 0] Data_in;
input clock,reset;
reg  [word_size_in-1 : 0] Samples[1 : order];
integer k;

// 串行实现成累加
assign Data_out = b0*Data_in + b1*Samples[1] + b2*Samples[2] + b3*Samples[3]
    		  + b4*Samples[4] + b5*Samples[5] + b6*Samples[6] + b7*Samples[7] 
+ b8*Samples[8];

// 完成移位的功能
always @ (posedge clock)
   if(reset == 1) begin
      for(k=1; k<=order; k=k+1)
         Samples[k] <= 0;
   end
   else begin
      Samples[1] <= Data_in;
      for(k=2; k<=order; k=k+1)
         Samples[k] <= Samples[k-1];
   end

endmodule

