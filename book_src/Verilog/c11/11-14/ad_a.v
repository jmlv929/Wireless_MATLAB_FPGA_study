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
input reset, we_coe; // we_coe为高时，才能将加权因子写入RAM中
input [15:0] x_r, x_i; // 数据速率为3.84Mbps
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

//SRL16单元的写控制信号,在cnt=0的时刻写一个数
assign we = (cnt == 0) ? 1 : 0;

// 由于复数乘法器需要4个时钟才能完成计算，所以对于累加器而言，
// 当cnt=4的时刻，本次累加的第一个数才达到，
// 此刻将bypass信号拉高，完成上次累加结果的输出
assign bypass = (cnt == 4) ? 1 : 0;

// 声明众多IPcore之间的连线变量
wire [15:0] ar, ai, br, bi, pr, pi;
wire bypass, we, wea, web;
wire [31:0] ram_out; //高16位为实部，低16位为虚部
// RAM的A口只能用来读取数据
assign wea = 0;

// 调用SRL16的移位寄存结构，用于滤波数据的缓存
shift16 shift16_01(
	.d(x_r), .spra(cnt), .clk(clk_61p44MHz), 
	.we(we),	.spo(ar));
shift16 shift16_02(
	.d(x_i), .spra(cnt), .clk(clk_61p44MHz), 
	.we(we),	.spo(ai));
	
// 调用复数乘法器
aa_cmult aa_cmult(
	.ar(ar), .ai(ai), .br(ram_out[31:16]), .bi(ram_out[15:0]), 
	.pr(pr), .pi(pi), .clk(clk_61p44MHz), .ce(reset));

// 调用2个实数累加器实现一个复数累加器
aa_adder aa_adder01(
	.B(pr), .Q(y_r), .CLK(clk_61p44MHz), .BYPASS(bypass));
aa_adder aa_adder02(
	.B(pi), .Q(y_i), .CLK(clk_61p44MHz), .BYPASS(bypass));

// 调用一个双口BLOCK RAM,位宽为32比特，深度为16
aa_bram aa_bram(//A口只读//B口只写
	.clka(clk_61p44MHz), .addra(cnt), .wea(wea), .douta(ram_out), 
	.clkb(clk_61p44MHz), .dinb({coe_r, coe_i}), .addrb(address),
	.web(we_coe));

endmodule
