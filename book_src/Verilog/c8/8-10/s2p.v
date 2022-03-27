`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:13:36 10/05/2007 
// Design Name: 
// Module Name:    s2p 
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
module s2p(clk, clk_div2, reset, x, b_i, b_q);
input clk;
input clk_div2;
input reset;
input x; //��0����1����1����-1��
output b_i, b_q;

reg b_i, b_q;
reg [1:0] x_t, d_t; //���ڼ����ֱ���
wire d_x; //�������ź�
always @(posedge clk) begin
   if(!reset) begin
	   x_t <= 0;
		d_t <= 0;
	end
	else begin
	   x_t[1:0] <= {x_t[0], x}; 
      d_t[1:0] <= {d_t[0], d_x};	
   end		
end

// ��ɲ��Ԥ����, d_x(n) = x(n)*x(n-1)
assign d_x = (x_t==2'b11) ? 0 :(x_t==2'b00) ? 0 : 1;

// ����������I��Q�ź�
reg s_flag; //���ű�־
always @(posedge clk) begin
	if(!reset) begin
	   s_flag <= 0;
		b_i <= 0;
		b_q <= 0;
	end
	else begin
		if(d_t[1] == d_t[0])
			s_flag <= s_flag;
		else 
		   if(clk_div2)
            s_flag <= !s_flag;
         else
            s_flag <= s_flag;			
      if(clk_div2) //��ɷ����޸�
         b_i <= s_flag; 
      else
         b_q <= s_flag ^ d_t[1];		
	end	
end

endmodule
