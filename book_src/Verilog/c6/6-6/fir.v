`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:53:06 09/12/2007 
// Design Name: 
// Module Name:    fir 
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
module fir(clk,rst_n,fir_in,fir_out);

parameter IDATA_WIDTH = 12;   //输入数据位宽
parameter PDATA_WIDTH = 13;   //处理数据位宽
parameter FIR_TAP = 8;   //FIR抽头
parameter FIR_TAPHALF = 4;   //FIR抽头的一半
parameter COEFF_WIDTH = 12;   //系数位宽
parameter OUT_WIDTH = 27;    //输出位宽

parameter cof1 = 12'd41;
parameter cof2 = 12'd132;
parameter cof3 = 12'd341;
parameter cof4 = 12'd510;

input clk, rst_n;
input [IDATA_WIDTH-1 : 0] fir_in;
output [OUT_WIDTH-1 : 0] fir_out;

reg [OUT_WIDTH-1 : 0] fir_out;
reg [IDATA_WIDTH-1 : 0] fir_in_reg;
reg [PDATA_WIDTH-1 : 0] shift_buf[FIR_TAP-1 : 0];   //定义一个8位的移位寄存器
wire [PDATA_WIDTH-1 : 0] add07;
wire [PDATA_WIDTH-1 : 0] add16;
wire [PDATA_WIDTH-1 : 0] add25;
wire [PDATA_WIDTH-1 : 0] add34;

wire [PDATA_WIDTH+COEFF_WIDTH-1 : 0] mul1;
wire [PDATA_WIDTH+COEFF_WIDTH-1 : 0] mul2;
wire [PDATA_WIDTH+COEFF_WIDTH-1 : 0] mul3;
wire [PDATA_WIDTH+COEFF_WIDTH-1 : 0] mul4;
integer i,j;

always @ (posedge clk or negedge rst_n)
begin
   if(!rst_n)
      fir_in_reg <= 12'b0000_0000_0000;
   else
      fir_in_reg <= fir_in;
end

always @ (posedge clk or negedge rst_n)
begin
   if(!rst_n)
      for(i=0; i<=FIR_TAP-1; i=i+1)
         shift_buf[i] <= 13'b0000_0000_00000;
   else
      begin
         for(j=0; j<FIR_TAP-1; j=j+1)
            shift_buf[j+1] <= shift_buf[j];
         shift_buf[0] <= {fir_in_reg[IDATA_WIDTH-1],fir_in_reg};
      end
end

assign add07 = shift_buf[0] + shift_buf[7];
assign add16 = shift_buf[1] + shift_buf[6];
assign add25 = shift_buf[2] + shift_buf[5];
assign add34 = shift_buf[3] + shift_buf[4];

mult1 mult1(.a(cof1),.b(add07),.q(mul1), .clk(clk));
mult1 mult2(.a(cof2),.b(add16),.q(mul2), .clk(clk));
mult1 mult3(.a(cof3),.b(add25),.q(mul3), .clk(clk));
mult1 mult4(.a(cof4),.b(add34),.q(mul4), .clk(clk));

wire [25 : 0] add_mul12 = {mul1[24],mul1}+{mul2[24],mul2};
wire [25 : 0] add_mul34 = {mul3[24],mul3}+{mul4[24],mul4};

always @ (posedge clk or negedge rst_n)
begin
   if(!rst_n)
      fir_out <= 27'b0;
   else
      fir_out <= {add_mul12[25],add_mul12}+{add_mul34[25],add_mul34};
end

endmodule

