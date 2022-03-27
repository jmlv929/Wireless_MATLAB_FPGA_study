`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:37:26 07/20/2007 
// Design Name: 
// Module Name:    two_ASK 
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
module two_ASK(clk, reset, x, y);
input clk;
input reset;
input x; //�����ź�
output y;



// cnt �Ƿ�Ƶ������
reg  cnt;
// carriers��Ҫ���Ƶ��ز��ź�,�������ź�clk����4��Ƶ�õ�
reg carriers;

always @(posedge clk) begin
  if(!reset) begin
    cnt <= 1'b0;
    carriers <= 0;
  end
  else begin
    if (cnt == 1'b1) begin
       cnt <= 1'b0;
       carriers <= ~carriers;
    end
    else begin
       carriers <= carriers;
       cnt <= cnt + 1;
    end
  end
end

// �Ի����źŽ��е���
assign y = x & carriers;

endmodule
