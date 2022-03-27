`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:34:32 07/21/2007 
// Design Name: 
// Module Name:    QPSK 
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
module QPSK(clk, reset, x, y);
input clk;       //ϵͳ����ʱ��
input reset;     //ϵͳ�����ź�
input x;         //ϵͳ�����ź�
output y;        //QPSK��������ź�

reg [2:0] cnt;  //������ 
reg [1:0] x_x;  //�����źŵ��м�Ĵ���
reg [3:0] carriers;  //4·�ز��ź�
reg [1:0] y_y;

// ��ɼ����������ڶ�ģ��ʱ�ӷ�Ƶ
always @(posedge clk) begin
  if(!reset)
     cnt <= 3'b000;
  else
     cnt <= cnt +1;
end

//�Ĵ�����
always @(posedge clk) begin
  if(!reset)
     x_x <= 2'b00;
  else
      if(cnt[1:0]==2'b11)
         x_x <= {x_x[0], x};
		else
		   x_x <= x_x;
end


// �����ز��ź�
always @(posedge clk) begin
  if(!reset)
     carriers <= 4'b000;
  else begin
     case(cnt) 
			3'b000: begin
			      y_y <= x_x;
					carriers <= 4'b1100;	       				
			end
			3'b010: carriers <= 4'b1001;							
			3'b100: carriers <= 4'b0011;	
			3'b110: carriers <= 4'b0110;
			default: carriers <= carriers;
	  endcase
  end
     
end

assign y = (y_y == 2'b00) ? carriers[3] :
           (y_y == 2'b01) ? carriers[2] :
			  (y_y == 2'b10) ? carriers[1] :
			  (y_y == 2'b11) ? carriers[0] : 0;

endmodule
