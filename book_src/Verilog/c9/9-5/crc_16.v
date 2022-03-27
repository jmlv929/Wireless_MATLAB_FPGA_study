`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:50:09 10/09/2007 
// Design Name: 
// Module Name:    crc_16 
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
module crc_16(clk, reset, x, crc_reg, crc_s);
input clk;            //ϵͳ�鹤��ʱ��
input reset;          // ��λ�ź�
input x;             //������������
output [15:0] crc_reg; //CRC�������
output crc_s;   //CRCͬ���źţ���־��һ֡����Ľ���

reg [15:0] crc_reg;
reg crc_s;
reg [3:0] cnt;
wire [15:0] crc_enc;

always @(posedge clk) begin
	if(!reset) begin
		crc_reg <= 0;
		cnt <= 0;
	end
	else begin
	   crc_reg <= crc_enc;
		cnt <= cnt +1;
		if(cnt == 0)
		  crc_s <= 0;
		else
		  crc_s <= 1;
	end
end

assign crc_enc[0] = crc_reg[15]^x;
assign crc_enc[1] = crc_reg[0];
assign crc_enc[2] = crc_reg[1]^crc_reg[15]^x;
assign crc_enc[14:3] = crc_reg[13:2];
assign crc_enc[15] = crc_reg[14]^crc_reg[15]^x;

endmodule

