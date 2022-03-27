`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:33:23 10/02/2007 
// Design Name: 
// Module Name:    ad_a 
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
module ad_a(clk_61p44MHz, reset, x_r, x_i, y_r, y_i,
            address, we_coe, coe_r, coe_i);
input clk_61p44MHz;
input reset, we_coe; // we_coeΪ��ʱ�����ܽ���Ȩ����д��RAM��
input [15:0] x_r, x_i; // ��������Ϊ3.84Mbps
input [3:0] address;
input [15:0] coe_r, coe_i;
output [15:0] y_r, y_i;

reg [3:0] cnt;

always @(posedge clk_61p44MHz) begin
   if(!reset) 
	  cnt <= 0;
	else 
	  cnt <= cnt + 1;
end

//SRL16��Ԫ��д�����ź�,��cnt=0��ʱ��дһ����
assign we = (cnt == 0) ? 1 : 0;

// ���ڸ����˷�����Ҫ4��ʱ�Ӳ�����ɼ��㣬���Զ����ۼ������ԣ�
// ��cnt=4��ʱ�̣������ۼӵĵ�һ�����Ŵﵽ��
// �˿̽�bypass�ź����ߣ�����ϴ��ۼӽ�������
assign bypass = (cnt == 4) ? 1 : 0;

// �����ڶ�IPcore֮������߱���
wire [15:0] ar, ai, br, bi, pr, pi;
wire bypass, we, wea, web;
wire [31:0] ram_out; //��16λΪʵ������16λΪ�鲿
// RAM��A��ֻ��������ȡ����
assign wea = 0;

// ����SRL16����λ�Ĵ�ṹ�������˲����ݵĻ���
shift16 shift16_01(
	.d(x_r), .spra(cnt), .clk(clk_61p44MHz), 
	.we(we),	.spo(ar));
shift16 shift16_02(
	.d(x_i), .spra(cnt), .clk(clk_61p44MHz), 
	.we(we),	.spo(ai));
	
// ���ø����˷���
aa_cmult aa_cmult(
	.ar(ar), .ai(ai), .br(ram_out[31:16]), .bi(ram_out[15:0]), 
	.pr(pr), .pi(pi), .clk(clk_61p44MHz), .ce(reset));

// ����2��ʵ���ۼ���ʵ��һ�������ۼ���
aa_adder aa_adder01(
	.B(pr), .Q(y_r), .CLK(clk_61p44MHz), .BYPASS(bypass));
aa_adder aa_adder02(
	.B(pi), .Q(y_i), .CLK(clk_61p44MHz), .BYPASS(bypass));

// ����һ��˫��BLOCK RAM,λ��Ϊ32���أ����Ϊ16
aa_bram aa_bram(//A��ֻ��//B��ֻд
	.clka(clk_61p44MHz), .addra(cnt), .wea(wea), .douta(ram_out), 
	.clkb(clk_61p44MHz), .dinb({coe_r, coe_i}), .addrb(address),
	.web(we_coe));

endmodule
