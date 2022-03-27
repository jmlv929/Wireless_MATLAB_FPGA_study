`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:44:16 09/22/2007 
// Design Name: 
// Module Name:    cic2_interp 
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
module cic2_interp(clk_3p84MHz, clk_7p68MHz, reset, x, y);
		input clk_7p68MHz;            // ģ�鹤��ʱ��
		input clk_3p84MHz;           // ����ֵΪclk��һ��
		input reset;
		input [15:0] x;
		output [15:0] y;

		reg [31:0] x_t, y_t;  // ������λ�ļĴ���
		reg [15:0] int_out, temp; //�м����


		always@(posedge clk_3p84MHz) begin
		   if(!reset) begin //���Ĵ�������ֵ
				x_t <= 0;
			   int_out <= 0;
			end
			else begin
				x_t <= {x_t[15:0], x};
				int_out <= x_t[15:0] + x_t[31:16];
			end

		end

		always@(posedge clk_7p68MHz) begin
			if(!reset) begin
				y_t <= 0;
				temp <= 0;
			end
			else begin
				if(clk_3p84MHz == 1)  //��ɲ�ֵ
					temp <= 0;
				else 
					temp <= int_out;
				y_t <= {y_t[15:0], temp};
			end
		end
		
		assign y = y_t[15:0] - y_t[31:16];// �����״�˲�
		
endmodule
