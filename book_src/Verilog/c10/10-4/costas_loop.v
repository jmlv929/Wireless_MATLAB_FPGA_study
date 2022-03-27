`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:54:01 08/07/2007 
// Design Name: 
// Module Name:    costas_loop 
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
module costas_loop(clk, clk_data, reset, costas_in, costas_out);
input clk;
input clk_data;
input reset;
input [15:0] costas_in;
output [15:0] costas_out;

wire [15:0] c_wave, s_wave, c_out, s_out;
wire [15:0] i_lpf, q_lpf, e_out; 
wire [23:0] dds_in;

costas_mult costas_mult(
            .clk(clk_data), 
				.reset(reset), 
				.s_in(costas_in), 
				.v_1(c_wave), 
				.v_2(s_wave), 
				.v_3(c_out), 
				.v_4(s_out));

costas_lpf costas_lpf_i(
				.CLK(clk), 
				.RESET(!reset),
				.DIN(c_out), 
				.DOUT(i_lpf));
				
costas_lpf costas_lpf_q(
				.CLK(clk), 
				.RESET(!reset),
				.DIN(s_out), 
				.DOUT(q_lpf));	

err_mult err_mult(
				.clk(clk_data), 
				.reset(reset), 
				.a(i_lpf), 
				.b(q_lpf), 
				.q(e_out));	
				
costas_lf costas_lf(
				.clk(clk_data), 
				.reset(reset), 
				.a(e_out), 
				.q(dds_in[23:8]));
				
assign dds_in[7:0] = 0;				
coastas_dds coastas_dds(
				.clk(clk), 
				.reset(reset), 
				.data(dds_in), 
				.y1(s_wave), 
				.y2(c_wave));	

assign costas_out = s_wave;
				
endmodule
