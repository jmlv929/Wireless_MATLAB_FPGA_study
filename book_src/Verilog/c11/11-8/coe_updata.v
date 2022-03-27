`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:40:02 09/02/2007 
// Design Name: 
// Module Name:    coe_updata 
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
module coe_updata(clk, reset, x_i, x_q, y_i, y_q);
parameter lamda = 8;
input clk;
input reset;
input [15:0] x_i;
input [15:0] x_q;
output [15:0] y_i;
output [15:0] y_q;

wire [15:0] x_t_i, x_t_q;
wire [15:0] y_t_i, y_t_q;

assign x_t_i = x_i>>lamda + y_t_i;
assign x_t_q = x_q>>lamda + y_t_q;

assign y_i = (!reset) ? 0 : y_t_i; 
assign y_q = (!reset) ? 0 : y_t_q; 

//系数更新模块使用一个深度为32的移位寄存器来实现
shiftreg3 shiftreg3_i(
  .clk(clk), 
  .d(x_t_i),
  .q(y_t_i)
);

shiftreg3 shiftreg3_q(
  .clk(clk), 
  .d(x_t_q),
  .q(y_t_q)
);
endmodule
