`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:40:27 08/25/2007 
// Design Name: 
// Module Name:    fft_block_lms 
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
module fft_block_lms(clk, reset, x_i, x_q, d_i, d_q, y_out_i, y_out_q);
input clk;//模块的处理时钟，其大小是数据速率的2倍
input reset;
input [15:0] x_i;
input [15:0] x_q;
input [15:0] d_i;
input [15:0] d_q;
output [15:0] y_out_i;
output [15:0] y_out_q;

wire [15:0] x_t_i, x_t_q, e_i, e_q;
wire [15:0] fft1_i, fft1_q;
wire [15:0] ifft2_i, ifft2_q;
wire [15:0] fft3_i, fft3_q;
wire [15:0] fft4_5_i, fft4_5_q;
wire [15:0] conj_i, conj_q;
wire [15:0] cm1_i, cm1_q;
wire [15:0] ss1_i, ss1_q, so1_i, so1_q;
wire [15:0] coe_1, coe_q;

assign y_out_i = (!reset) ? 0 : so1_i;
assign y_out_q = (!reset) ? 0 : so1_q;

blockconnect blockconnect(
     .clk(clk), 
	  .reset(reset), 
	  .x_i(x_i), 
	  .x_q(x_q), 
	  .y_out_i(x_t_i), 
	  .y_out_q(x_t_q));

fft_block fft_block_01(
     .clk(clk), 
	  .reset(reset), 
	  .start(reset),
	  .x_i(x_t_i), 
	  .x_q(x_t_q),
	  .y_i(fft1_i), 
	  .y_q(fft1_q), 
	  .y_index(y_index));

cmult cmult_01(
     .clk(clk), 
	  .reset(reset), 
	  .x_i(fft1_i), 
	  .x_q(fft1_q), 
	  .c_i(coe_i), 
	  .c_q(coe_q), 
	  .y_i(cm1_i), 
	  .y_q(cm1_q));

ifft_block ifft_block_02(
     .clk(clk), 
	  .reset(reset), 
	  .start(reset),
	  .x_i(cm1_i), 
	  .x_q(cm1_q),
	  .y_i(ifft2_i), 
	  .y_q(ifft2_q)
     );
	  
save_sub save_sub(
     .clk(clk), 
	  .reset(reset), 
	  .x_i(ifft2_i), 
	  .x_q(ifft2_q),
     .d_i(d_i), 
	  .d_q(d_q), 
	  .e_i(ss1_i), 
	  .e_q(ss1_q)
	  );

insert insert(
     .clk(clk), 
	  .reset(reset), 
	  .x_i(ss1_i), 
	  .x_q(ss1_q),
	  .y_i(so1_i), 
	  .y_q(so1_q));

fft_block fft_block_03(
     .clk(clk), 
	  .reset(reset), 
	  .start(reset),
	  .x_i(so1_i), 
	  .x_q(so1_q),
	  .y_i(fft3_i), 
	  .y_q(fft3_q)
	  );
	  
gonge gonge(
     .clk(clk), 
	  .reset(reset), 
	  .x_i(fft1_i), 
	  .x_q(fft1_q), 
	  .y_i(conj_i), 
	  .y_q(conj_q)
	  );

ifft_fft_0405 ifft_fft_0405(
     .clk(clk), 
	  .reset(reset), 
	  .x_i(fft3_i), 
	  .x_q(fft3_q), 
	  .c_i(conj_i), 
	  .c_q(conj_q),
	  .y_i(fft4_5_i), 
	  .y_q(fft4_5_q)
	  );
coe_updata coe_updata(
     .clk(clk), 
	  .reset(reset), 
	  .x_i(fft4_5_i), 
	  .x_q(fft4_5_q), 
	  .y_i(coe_i), 
	  .y_q(coe_q)
	  );
endmodule
