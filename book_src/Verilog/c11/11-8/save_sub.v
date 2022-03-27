`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:54:14 09/02/2007 
// Design Name: 
// Module Name:    save_sub 
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
module save_sub(clk, reset, x_i, x_q,
                d_i, d_q, e_i, e_q);
input clk;  //clk的频率是数据的2倍
input reset;
input [15:0] x_i;
input [15:0] x_q;
input [15:0] d_i;
input [15:0] d_q;
output [15:0] e_i;
output [15:0] e_q;

reg [4:0] cnt;
reg [3:0] spra;
reg mycnt;
wire [15:0] y_i, y_q;
wire [15:0] spo4_i, spo4_q, spo5_i, spo5_q;

//丢弃前面16个数
always @(posedge clk) begin
   if(!reset) begin
		cnt <= 0;
		spra <= 0;
		mycnt <= 0;
	end
	else begin
	   cnt <= cnt + 1;
		spra <= spra + cnt[0];
		if(cnt == 5'b11111)
		   mycnt <= ~mycnt;
		else
		   mycnt <= mycnt;
	end
end

assign we4 = mycnt ? 0 : cnt[4];
assign we5 = (!mycnt) ? 0 : cnt[4];

assign y_i = mycnt ? spo4_i : spo5_i;
assign y_q = mycnt ? spo4_q : spo5_q; 

assign e_i = y_i - d_i;
assign e_q = y_q - d_q;

//使用SRL16作数据块级联,需要两个完成数据交互
srl16_w16_d16 srl16_w16_d16_04_i(
		.d(x_i),
		.spra(spra[3:0]),
		.clk(clk),
		.we(we4),
		.spo(spo4_i));
srl16_w16_d16 srl16_w16_d16_04_q(
		.d(x_q),
		.spra(spra[3:0]),
		.clk(clk),
		.we(we4),
		.spo(spo4_q));
		
srl16_w16_d16 srl16_w16_d16_05_i(
		.d(x_i),
		.spra(spra[3:0]),
		.clk(clk),
		.we(we5),
		.spo(spo5_i));
srl16_w16_d16 srl16_w16_d16_05_q(
		.d(x_q),
		.spra(spra[3:0]),
		.clk(clk),
		.we(we5),
		.spo(spo5_q));
		
endmodule

