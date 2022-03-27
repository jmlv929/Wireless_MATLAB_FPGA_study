`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:34:32 07/22/2007 
// Design Name: 
// Module Name:    two_fsk 
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
module two_fsk(clk, reset, x, y);
input clk;       //ϵͳ����ʱ��
input reset;     //ϵͳ�����ź�
input x;         //ϵͳ�����ź�
output y;        //2-FSK��������ź�


reg [2:0] cnt1;
reg [1:0] cnt2; 

reg f1;
reg f2;

always @(posedge clk) begin
  if(!reset) begin
     cnt1 <= 3'b000;
	  f1 <= 0;
  end
  else
     if(cnt1 == 3'b111) 
	    cnt1 <= 3'b000;
	  else
	    cnt1 <= cnt1 + 1;
	  f1 <= cnt1[2];
end


always @(posedge clk) begin
  if(!reset) begin
     cnt2 <= 2'b00;
	  f2 <= 0;
  end
  else
     if(cnt2 == 2'b11)
	    cnt2 <= 2'b00;
	  else
	    cnt2 <= cnt2 + 1;
	  f2 <= cnt2[1];
end

assign y = (reset == 0) ? 0 :
           (x == 1) ? f1 : f2;

endmodule
