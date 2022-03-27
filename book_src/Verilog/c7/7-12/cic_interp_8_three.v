`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:26:31 09/18/2007 
// Design Name: 
// Module Name:    cic_interp_8_three 
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
module cic_interp_8_three(clk,clk1, reset, x_in, y_out);
input clk;       // ϵͳ����ʱ�ӣ���x_in���ʵĶ���
input clk1;      // clkʱ�ӵ�һ��
input reset;     //  ϵͳ�����ź�
input [7:0] x_in;     // ����CIC�˲��������ź�
output [7:0] y_out;   // ����CIC�˲�������ź�

reg [7:0] y_out;   // ��������óɼĴ�����
reg [15:0] i1, i2, i3, c1, c2, c3;  // ������λ�ļĴ���
reg [7:0] int_out1, int_out2, int_out3;
reg [7:0] comb_out1, comb_out2, temp;

always @(posedge clk1) begin 			// 3�������˲����ļ���
   if(!reset) begin
		i1 <= 0;
      i2 <= 0;
      i3 <= 0;
      int_out1 <= 0;
      int_out2 <= 0;
      int_out3 <= 0;
   end
   else begin   
		i1 <= {i1[7:0], x_in};
      i2 <= {i1[7:0], int_out1};
      i3 <= {i1[7:0], int_out2};
      int_out1 <= i1[7:0] + i1[15:8];
      int_out2 <= i2[7:0] + i2[15:8];
      int_out3 <= i3[7:0] + i3[15:8];
	end
end      

// 3����״�˲����ļ���
always @(posedge clk) begin
   if(!reset) begin
	   temp <= 0;
		c1 <= 0;
		c2 <= 0;
		c3 <= 0;
		comb_out1 <= 0;
		comb_out2 <= 0;
		y_out <= 0;
	end
	else begin
	  if(clk1 == 1)
		  temp <= 0;                  //���2����ֵ
      else
        temp <= int_out3;
      c1 <= {c1[7:0], temp };             //���3����״�˲���
      c2 <= {c1[7:0], comb_out1};
      c3 <= {c1[7:0], comb_out2};
      comb_out1 <= c1[7:0] - c1[15:8];
      comb_out2 <= c2[7:0] - c2[15:8];
      y_out <= c3[7:0] - c3[15:8];
	end
end      

endmodule

