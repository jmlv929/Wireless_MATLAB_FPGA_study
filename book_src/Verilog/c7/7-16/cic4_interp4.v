`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:46:12 09/22/2007 
// Design Name: 
// Module Name:    cic4_interp4 
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
module cic4_interp4(clk_30p72MHz, clk_7p68MHz, reset, x, y);
		input clk_30p72MHz;            // ģ�鹤��ʱ��
		input clk_7p68MHz;           // ����ֵΪclk��1/4
		input reset;
		input [15:0] x;
		output [15:0] y;

		reg [31:0] x_t, y_t;  // ������λ�ļĴ���
		reg [31:0] int_out, temp; //�м����
      reg [1:0] cnt;

		always@(posedge clk_7p68MHz) begin
		   if(!reset) begin //���Ĵ�������ֵ
				x_t <= 0;
			   int_out <= 0;
			end
			else begin
				x_t <= {x_t[15:0], x};
				int_out <= x_t[15:0] + x_t[31:16];
			end

		end

		always@(posedge clk_30p72MHz) begin
			if(!reset) begin
				y_t <= 0;
				temp <= 0;
				cnt <= 0;
			end
			else begin
			   cnt <= cnt + 1;
				if(cnt == 0)  //���4����ֵ
					temp <= int_out;
				else 
					temp <= 0;
				y_t <= {y_t[15:0], temp};
			end
		end
		
		assign y = y_t[15:0] - y_t[31:16];// �����״�˲�
		
endmodule

