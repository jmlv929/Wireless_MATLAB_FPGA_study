`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:22:09 09/02/2007 
// Design Name: 
// Module Name:    ifft_block 
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
module ifft_block(clk, reset, start, 
                 x_i, x_q, y_i, y_q, y_index);
input clk; 
input start;
input reset;
input [15:0] x_i;
input [15:0] x_q;
output [15:0] y_i;
output [15:0] y_q;
output [4:0] y_index;

wire scale_we, cfft;
wire [5:0] scale;
wire [4:0] x_index;
assign scale_we = 1;
assign scale = 6'b101010;
assign cfft = 0;
assign x_index = (!start) ? 0 : x_index + 1; 

fft_w16_p32 fft_w16_p32(
  .ce(reset), //ģ�������źţ�����Ч
  //fft/iffft���ö˿ڵĿ����źţ��ߵ�ƽʱ����������
  .fwd_inv_we(start), 
  .rfd(rfd), //������Ч�ź�
  //startFFT��ʼ�źţ�����Ч��
  //��ʼFFT
  .start(start), 
   // fft/iffft���ö˿ڵĿ����ź�,1ʱ��ΪFFT��0ʱ��ΪIFFT
  .fwd_inv(cfft),
  // ���ſ����ź�
  .scale_sch_we(scale_we), 
  .clk(clk),
  // ���ſ����ź�
  .scale_sch(scale), 
  .xn_re(x_i), 
  .xk_im(y_q), 
  .xn_index(x_index), 
  .xk_re(y_i), 
  .xn_im(x_q), 
  .xk_index(y_index)
);

endmodule
