`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:41:27 08/25/2007 
// Design Name: 
// Module Name:    fir_rls 
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
module fir_rls(clk, reset, x_in, d_in, y_out);
input clk;
input reset;
input [15:0] d_in;
input [15:0] x_in;
output [15:0] y_out;
//��ע: ��������lamda=1/2

//����Ӧ�˲����ĳ�ͷϵ��
wire [15:0] w1, w2;
//��ɾ�����˵Ĺ��ɾ���
wire [15:0] P0_0, P0_1, P1_0, P1_1; 
wire [15:0] ppt0_0, ppt0_1, ppt1_0, ppt1_1;
reg [31:0] x_t;

wire [15:0] kxp_0t, kxp_1t, kxp_2t, kxp_3t,
            kxp_4t, kxp_5t, kxp_6t, kxp_7t;
wire [15:0] kup0_0, kup0_1, kup1_0, kup1_1;

//ϵ�����µ���������
wire [15:0] delta1, delta2;

//������������
always @(posedge clk) begin
   if(!reset) 
	   x_t <= 0;
	else 
	   x_t[31:0] <= {x_t[15:0], x_in};
end

// x��Ҫ�Ĵ�25��ʱ������
shiftreg25 shiftreg25_01(
    .clk(clk), .d(x_t[15:0]), .q(x_t1));    
shiftreg25 shiftreg25_02(
    .clk(clk), .d(x_t[31:16]), .q(x_t2));    
	 
// P������Ҫ�Ĵ�28��ʱ������
wire [15:0] P0_0t, P0_1t, P1_0t, P1_1t;
shiftreg28 shiftreg28_01(
    .clk(clk), .d(P0_0), .q(P0_0t));    
shiftreg28 shiftreg28_02(
    .clk(clk), .d(P0_1), .q(P0_1t));    
shiftreg28 shiftreg28_03(
    .clk(clk), .d(P1_0), .q(P1_0t));    
shiftreg28 shiftreg28_04(
    .clk(clk), .d(P1_1), .q(P1_1t));    
	 
assign	   w1 = w1 + delta1;
assign		w2 = w2 + delta2;
		//���¾���P
assign		P0_0[15:0] = reset ? {P0_0 - kup0_0}:100;
assign		P0_1[15:0] = reset ? {P0_1 - kup0_1}:100;
assign		P1_0[15:0] = reset ? {P1_0 - kup1_0}:100; 
assign		P1_1[15:0] = reset ? {P1_1 - kup1_1}:100; 

// ������׵ľ������
wire [15:0] v0, v1, p_0, p_1, p_2, p_3;
rlsmult rlsmult01( 
  .clk(clk), .a(x_t[15:0]), .b(P0_0), .q(p_0));
rlsmult rlsmult02(
  .clk(clk), .a(x_t[31:16]), .b(P0_1), .q(p_1)); 
rlsmult rlsmult03(
  .clk(clk), .a(x_t[15:0]), .b(P1_0), .q(p_2));
rlsmult rlsmult04(
  .clk(clk), .a(x_t[31:16]), .b(P1_1), .q(p_3));  
assign v0[15:0] = p_0[15:0] + p_1[15:0];
assign v1[15:0] = p_2[15:0] + p_3[15:0];

// ����Kn����ĳ˷���
wire [15:0] kn_uv0, kn_uv1, kn_t0, kn_t1;
rlsmult rlsmult09(
  .clk(clk), .a(v0), .b(x_t[15:0]), .q(kn_uv0));
rlsmult rlsmult10(
  .clk(clk), .a(v1), .b(x_t[15:0]), .q(kn_uv1));
assign kn_t0[15:0] = 4096 + kn_uv0[15:0]; //4096Ϊ��1
assign kn_t1[15:0] = 4096 + kn_uv1[15:0];

// ����kn�ĳ�����
wire [15:0] k_0, k_1;
div16 div16_01( //��Ϊ��ĸ���ڷ��ӣ�����ֻȡ����
	.clk(clk),.dividend({v0[14:0],0}),.divisor(kn_t0),
	.remainder(k_0));
div16 div16_02( //��Ϊ��ĸ���ڷ��ӣ�����ֻȡ����
	.clk(clk),.dividend({v1[14:0],0}),.divisor(kn_t1),
	.remainder(k_1));	

//��λ�Ĵ�3��ʱ��,������λ�Ĵ�����IPcore
wire [15:0] k_0t, k1_t;
shiftreg3 shiftreg3_01
  (.clk(clk), .d(k_0), .q(k_0t));
shiftreg3 shiftreg3_02
  (.clk(clk), .d(k_1), .q(k_1t));

// �˲������
wire [15:0] y_0, y_1, y_t, e_n;
assign y_t = y_0 + y_1;
assign y_out = y_t;
assign e_n = d_in - y_t;
rlsmult rlsmult05(
  .clk(clk), .a(x_t1), .b(w1), .q(y_0));
rlsmult rlsmult06(
  .clk(clk), .a(x_t2), .b(w2), .q(y_1)); 

// ϵ������ģ���еĳ˷���

rlsmult rlsmult07(
  .clk(clk), .a(k_0), .b(e_n), .q(delta1));
rlsmult rlsmult08(
  .clk(clk), .a(k_1), .b(e_n), .q(delta2)); 


//��ɾ�������k*x 
wire [15:0] kx0_0t, kx0_1t, kx1_0t, kx1_1t;
rlsmult rlsmult11( //���ó˷���
  .clk(clk), .a(x_t[15:0]), .b(k_0t), .q(kx0_0t));
rlsmult rlsmult12(
  .clk(clk), .a(x_t[15:0]), .b(k_1t), .q(kx0_1t)); 
rlsmult rlsmult13(
  .clk(clk), .a(x_t[31:16]), .b(k_0t), .q(kx1_0t));
rlsmult rlsmult14(
  .clk(clk), .a(x_t[31:16]), .b(k_1t), .q(kx1_1t));  
 
//�ٴ���ɾ������,2*2�ľ�����Ҫ8���˷���
rlsmult rlsmult15( //���ó˷���
  .clk(clk), .a(kx0_0t), .b(P0_0t), .q(kxp_0t));
rlsmult rlsmult16(
  .clk(clk), .a(kx0_1t), .b(P1_0t), .q(kxp_1t)); 
rlsmult rlsmult17(
  .clk(clk), .a(kx0_0t), .b(P1_0t), .q(kxp_2t));
rlsmult rlsmult18(
  .clk(clk), .a(kx0_1t), .b(P1_1t), .q(kxp_3t)); 
rlsmult rlsmult19( 
  .clk(clk), .a(kx1_0t), .b(P0_0t), .q(kxp_4t));
rlsmult rlsmult20(
  .clk(clk), .a(kx1_1t), .b(P1_0), .q(kxp_5t)); 
rlsmult rlsmult21(
  .clk(clk), .a(kx1_0t), .b(P0_1), .q(kxp_6t));
rlsmult rlsmult22(
  .clk(clk), .a(kx1_1t), .b(P1_1), .q(kxp_7t));
assign kup0_0 = kxp_0t + kxp_1t;  
assign kup1_0 = kxp_2t + kxp_3t;  
assign kup0_1 = kxp_4t + kxp_5t; 
assign kup1_1 = kxp_6t + kxp_7t;  

 
endmodule
