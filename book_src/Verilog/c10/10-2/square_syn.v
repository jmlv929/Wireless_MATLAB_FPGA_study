`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:39:19 08/06/2007 
// Design Name: 
// Module Name:    square_syn 
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
module square_syn(clk, clk_x, reset, x, y);
    input clk;      // DDSģ��Ĺ���ʱ��
    input clk_x;    // �����źŵĹ���ʱ��
    input reset;    // ģ������ź�
    input [15:0] x;  // 16���ص������ź�
    output [15:0] y; // 16���ص�����ź�

parameter c1 = 8; //��·�˲���ϵ��
parameter c2 = 2; 

reg [15:0] y, a, b, lf_t, lf_out;  
reg [31:0] s, lf_d;  //�����м����
wire [31:0] q, qx; // qΪ�˷��������, qxΪ�����������
wire [15:0] y1;    // DDS���
wire [4:0] add;    // DDS����ͨ��
wire [27:0] data;  // DDS���룬����λ�ۼӷ���
assign add = 5'b00000;
assign qx = q^{y1,16'b0000_0000_0000_0000};

always @(posedge clk_x) begin //���Ƴ˷���������
	if(!reset) begin
		a <= 0;
		b <= 0; 	
		s <= 0;
		y <=0;
	end
	else begin
	   a <= x;
		b <= x;
		// ���㻷·�˲�
		s <= {s[15:0],qx[31:16]}; //ȡ�˷����ĸ�16λ
      lf_t[15:0] <= qx[31:16]<<1 + lf_d[31:16];
		lf_d[31:0] <= {lf_d[15:0], lf_t};
		lf_out <= s[31:16]<<3 + lf_t;
		y <= y1; //2��Ƶ
	end	
end
	 
// ʵ�����˷�����IPcore����������Ϊ16���أ����Ϊ32���ء�	 
mult mult(  
  .ce(reset),   //ʱ���ź�
  .clk(clk_x),  //�˷�������ʱ��
  .a(a),        //������
  .b(b), 
  .q(q)         //����ź�
);

// ����DDSģ��
assign data = (!reset) ? 0 : data + lf_out;
mydds mydds(
   .DATA(data),
   .WE(reset),
   .A(add),
   .CLK(clk),
   .SINE(y1)
   );
	
endmodule
