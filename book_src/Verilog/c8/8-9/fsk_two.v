`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:41:01 07/22/2007 
// Design Name: 
// Module Name:    fsk_two 
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
module fsk_two(clk, reset, x, y);
input clk;       //ϵͳ����ʱ��
input reset;     //ϵͳ�����ź�
input x;         //ϵͳ�����ź�:2-FSK�����ź�
output y;        //�������ź�

reg y;
// �ṩһ���о�ʱ��
reg [4:0] cnt;
// �ṩ�о�����
reg [2:0] cnt1;
 
always @(posedge clk) begin
  if(!reset)
     cnt <= 5'b00000;
  else
     if(cnt == 5'b10011)
			cnt <= 5'b00000;
	  else
			cnt <= cnt +1;
end

always @(posedge x) begin
  if(!reset) 
	 cnt1 <= 3'b000;
  else
    if(cnt == 5'b00000) begin
		 if(cnt1 > 4) 
			 y <= 0;
		 else
		    y <= 1;
		 cnt1 <= 3'b000;
	 end
	 else
	    cnt1 <= cnt1 + 1;   
end

endmodule
