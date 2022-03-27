`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:55:16 10/06/2007 
// Design Name: 
// Module Name:    IIR_Filter_8 
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
module IIR_Filter_8(Data_out,Data_in,clock,reset);

parameter order = 8;
parameter word_size_in = 8;
parameter word_size_out = 2*word_size_in + 2;

parameter b0 = 4;    //前馈滤波器系数
parameter b1 = 22;    
parameter b2 = 65;    
parameter b3 = 110;    
parameter b4 = 110;    
parameter b5 = 65;    
parameter b6 = 22;    
parameter b7 = 6;        

parameter a1 = 25;        //反馈滤波器系数
parameter a2 = -70;    
parameter a3 = 99;    
parameter a4 = -85;    
parameter a5 = 47;    
parameter a6 = -16;    
parameter a7 = 4;    
parameter a8 = 1;  

output [word_size_out-1 : 0] Data_out;
input [word_size_in-1 : 0] Data_in;
input clock,reset;

reg [word_size_in-1 : 0] Samples_in[1 : order];
reg [word_size_in-1 : 0] Samples_out[1 : order];
wire [word_size_out-1 : 0] Data_feedforward;
wire [word_size_out-1 : 0] Data_feedback;
integer k;

assign Data_feedforward = b0*Data_in + b1*Samples_in[1] + b2*Samples_in[2] + b3*Samples_in[3]+ b4*Samples_in[4] + b5*Samples_in[5] +                     b6*Samples_in[6] + b7*Samples_in[7];
                         
assign Data_feedback = a1*Samples_out[1] + a2*Samples_out[2] + a3*Samples_out[3] + a4*Samples_out[4] + a5*Samples_out[5] + a6*Samples_out[6] +                        a7*Samples_out[7] + a8*Samples_out[8];

assign Data_out = Data_feedforward + Data_feedback;

always @ (posedge clock)
   if(reset == 1)
      for(k=1; k<=order; k=k+1) begin
         Samples_in[k] <= 0;
         Samples_out[k] <= 0;
      end
   else begin
      Samples_in[1] <= Data_in;
      Samples_out[1] <= Data_out;
      for(k=2; k<=order; k=k+1) begin
         Samples_in[k] <= Samples_in[k-1];
         Samples_out[k] <= Samples_out[k-1];
      end
   end

endmodule

