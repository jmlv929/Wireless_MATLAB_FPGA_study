`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:01:45 10/06/2007 
// Design Name: 
// Module Name:    tcm_enc 
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
module tcm_enc(clk, reset, x, y);
input clk; //��������ʱ�ӣ�Ҳ��ģ�鹤��ʱ��
input reset;
input [1:0] x; // �����ź�
output [2:0] y; // ����ź�

reg [2:0] ccode;
reg [2:0] x_t;

always @(posedge clk) begin
   if(!reset) begin
      ccode <= 0;
      x_t <= 0;
   end
   else begin
      ccode[2:0] <= {ccode[1:0], x[1]};
      x_t[2:0] <= {x_t[1:0], x[0]};
   end
end

assign y[0] = x_t[1];
assign y[1] = x_t[2] ^ x_t[0]; //��ɾ������� 
assign y[2] = ccode[0];

endmodule

