`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:48:29 09/18/2007 
// Design Name: 
// Module Name:    crc_interp_2_single 
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
module cic_interp_2_single(clk, clk1, reset, x, y);
		input clk;            // ģ�鹤��ʱ��
		input clk1;           // ����ֵΪclk��һ��
		input reset;
		input [7:0] x;
		output [7:0] y;

		reg [15:0] x_t, y_t;  // ������λ�ļĴ���
		reg [7:0] int_out, temp; //�м����


		always@(posedge clk1) begin
		   if(!reset) begin //���Ĵ�������ֵ
				x_t <= 0;
			   int_out <= 0;
			end
			else begin
				x_t <= {x_t[7:0], x};
				int_out <= x_t[7:0] + x_t[15:8];
			end

		end

		always@(posedge clk) begin
			if(!reset) begin
				y_t <= 0;
				temp <= 0;
			end
			else begin
				if(clk1 == 1)
					temp <= 0;
				else 
					temp <= int_out;
				y_t <= {y_t[7:0], temp};
			end
		end
		
		assign y = y_t[7:0] - y_t[15:8];// �C ;
		
endmodule

