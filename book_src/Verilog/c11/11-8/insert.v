`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:05:10 09/02/2007 
// Design Name: 
// Module Name:    insert 
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
module insert(clk, reset, x_i, x_q, y_i, y_q);
input clk;
input reset;
input [15:0] x_i;
input [15:0] x_q;
output [15:0] y_i;
output [15:0] y_q;

reg [4:0] cnt;
reg [3:0] spra;
reg mycnt;
wire we6, we7;
wire [15:0] t_i, t_q;
wire [15:0] spo6_i, spo6_q, spo7_i, spo7_q;

always @(posedge clk) begin
   if(!reset) begin
	  cnt <= 0;
	  mycnt <= 0;
	  spra <= 0;
	end
	else begin
	  cnt <= cnt + 1;
	  if(cnt == 5'b11111)
	     mycnt <= !mycnt;
	  else
	     mycnt <= mycnt;
	  if(cnt > 5'b01111)
		  spra <= spra + 1;
	  else 
	     spra <= 0;
	end
end

assign y_i = cnt[4]? t_i : 0;
assign y_q = cnt[4]? t_q : 0;

assign we6 = mycnt ? 0 : cnt[0];
assign we7 = (!mycnt) ? 0 : cnt[0];

assign t_i = mycnt ? spo6_i : spo7_i;
assign t_q = mycnt ? spo6_q : spo7_q; 

//使用SRL16作数据块级联,需要两个完成数据交互
srl16_w16_d16 srl16_w16_d16_06_i(
		.d(x_i),
		.spra(spra[3:0]),
		.clk(clk),
		.we(we6),
		.spo(spo6_i));
srl16_w16_d16 srl16_w16_d16_06_q(
		.d(x_q),
		.spra(spra[3:0]),
		.clk(clk),
		.we(we6),
		.spo(spo6_q));
		
srl16_w16_d16 srl16_w16_d16_07_i(
		.d(x_i),
		.spra(spra[3:0]),
		.clk(clk),
		.we(we7),
		.spo(spo7_i));
srl16_w16_d16 srl16_w16_d16_07_q(
		.d(x_q),
		.spra(spra[3:0]),
		.clk(clk),
		.we(we7),
		.spo(spo7_q));

endmodule
