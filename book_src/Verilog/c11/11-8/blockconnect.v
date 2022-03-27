`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:20:51 08/29/2007 
// Design Name: 
// Module Name:    blockconnect 
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
module blockconnect(clk, reset, x_i, x_q, y_out_i, y_out_q);
	input clk;    //clk是数据速率的2倍
	input reset;  //模块控制信号
	input [15:0] x_i;
	input [15:0] x_q;
	output [15:0] y_out_i;
	output [15:0] y_out_q;
	
	reg [15:0] y_out_i, y_out_q;
	reg we1, we2, we3; //声明SRL16的控制变量
	wire[15:0] spo1_i, spo1_q,  spo2_i, spo2_q,
					spo3_i, spo3_q;
	reg [4:0] spra;
	reg [1:0] cnt;

	always @(posedge clk) begin
		if(!reset) begin
			we1 <= 0;
			we2 <= 0;
			we3 <= 0;
			spra <= 5'b11111;
			cnt <= 0;
		end
		else begin
		   spra <= spra - 1;    //SRL16地址发生器
			if(spra == 5'b11111) //判断标记计算器计数
			   if(cnt == 2'b10) 
				   cnt <= 0;
				else 
				   cnt <= cnt + 1;
			else 
			   cnt <= cnt;
			case(cnt)
			   2'b00: begin
					we1 <= !we1;
					we2 <= 0;
					we3 <= 0;
					if(spra < 4'b1111) begin
					   y_out_i <= spo2_i;
						y_out_q <= spo2_q;
					end
					else begin
						y_out_i <= spo3_i;
						y_out_q <= spo3_q;
               end					   
				end
			   2'b01: begin
					we1 <= 0;
					we2 <= !we2;
					we3 <= 0;				
					if(spra < 4'b1111) begin
					   y_out_i <= spo3_i;
						y_out_q <= spo3_q;
					end
					else begin
					   y_out_i <= spo1_i;
						y_out_q <= spo1_q;
               end						
				end
			   2'b10: begin
					we1 <= 0;
					we2 <= 0;
					we3 <= !we3;
					if(spra < 4'b1111) begin
					   y_out_i <= spo1_i;
						y_out_q <= spo1_q;
					end
					else begin
					   y_out_i <= spo2_i;
						y_out_q <= spo2_q;
               end						
				end	
            default: begin
	            we1 <= 0;
					we2 <= 0;
					we3 <= 0;
					y_out_i <= 0;
					y_out_q <= 0;	
            end				
			endcase
		end
	end
	
	//使用SRL16作数据块级联
	srl16_w16_d16 srl16_w16_d16_01_i(
		.d(x_i),
		.spra(spra[3:0]),
		.clk(clk),
		.we(we1),
		.spo(spo1_i));
	srl16_w16_d16 srl16_w16_d16_01_q(
		.d(x_q),
		.spra(spra[3:0]),
		.clk(clk),
		.we(we1),
		.spo(spo1_q));
		
	//使用SRL16作数据块级联
	srl16_w16_d16 srl16_w16_d16_02_i(
		.d(x_i),
		.spra(spra[3:0]),
		.clk(clk),
		.we(we2),
		.spo(spo2_i));
	srl16_w16_d16 srl16_w16_d16_02_q(
		.d(x_q),
		.spra(spra[3:0]),
		.clk(clk),
		.we(we2),
		.spo(spo2_q));
	
   //使用SRL16作数据块级联
	srl16_w16_d16 srl16_w16_d16_03_i(
		.d(x_i),
		.spra(spra[3:0]),
		.clk(clk),
		.we(we3),
		.spo(spo3_i));
	srl16_w16_d16 srl16_w16_d16_03_q(
		.d(x_q),
		.spra(spra[3:0]),
		.clk(clk),
		.we(we3),
		.spo(spo3_q));

endmodule

