`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:08 09/12/2007 
// Design Name: 
// Module Name:    ser_fir 
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
module ser_fir(clk,rst_n,fir_in,fir_out);

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

input clk, rst_n; //说明: clk的频率是数据速率的4倍
input [IDATA_WIDTH-1 : 0] fir_in;
output [OUT_WIDTH-1 : 0] fir_out;

reg [OUT_WIDTH-1 : 0] fir_out;
reg [IDATA_WIDTH-1 : 0] fir_in_reg;
reg [PDATA_WIDTH-1 : 0] shift_buf[FIR_TAP-1 : 0];   //定义一个8位的移位寄存器
reg [PDATA_WIDTH-1 : 0] add07;
reg [PDATA_WIDTH-1 : 0] add16;
reg [PDATA_WIDTH-1 : 0] add25;
reg [PDATA_WIDTH-1 : 0] add34;

reg [COEFF_WIDTH-1 : 0] cof_reg_maca;
reg [PDATA_WIDTH-1 : 0] add_reg_macb;
wire [COEFF_WIDTH+PDATA_WIDTH-1 : 0] result;
reg [OUT_WIDTH-1 : 0] sum;
reg [2 : 0] count;
integer i,j;

always @ (posedge clk or negedge rst_n) begin
   if(!rst_n)
      fir_in_reg <= 12'b0000_0000_0000;
   else 
      if(count[2]==1'b1)
         fir_in_reg <= fir_in;
end

always @ (posedge clk or negedge rst_n) begin
   if(!rst_n)
      for(i=0; i<=FIR_TAP-1;i=i+1)
         shift_buf[i] <= 13'b0000_0000_00000;
   else
      if(count[2]==1'b1) begin
         for(j=0; j<FIR_TAP-1; j=j+1)
            shift_buf[j+1] <= shift_buf[j];
         shift_buf[0] <= {fir_in_reg[IDATA_WIDTH-1], fir_in_reg};
      end
end

always @ (posedge clk or negedge rst_n) begin
   if(!rst_n) begin
         add07 <= 13'b0000_0000_00000;
         add16 <= 13'b0000_0000_00000;
         add25 <= 13'b0000_0000_00000;
         add34 <= 13'b0000_0000_00000;
      end
   else
      if(count[2]==1'b1)  begin
         add07 <= shift_buf[0] + shift_buf[7];
         add16 <= shift_buf[1] + shift_buf[6];
         add25 <= shift_buf[2] + shift_buf[5];
         add34 <= shift_buf[3] + shift_buf[4];
      end
end

always @ (posedge clk or negedge rst_n) 
begin
   if(!rst_n)
      count <= 3'b000;
   else
      if(count==3'b100)
         count <= 3'b000;
      else
         count <= count + 1'b1;
end

always @ (posedge clk or negedge rst_n) begin
   if(!rst_n)
      begin
         cof_reg_maca <= 12'b0000_0000_0000;
         add_reg_macb <= 13'b0000_0000_00000;
      end
   else
      case(count)
         3'b000: begin
                    cof_reg_maca <= cof1;
                    add_reg_macb <= add07;
                 end
         3'b001: begin
                    cof_reg_maca <= cof2;
                    add_reg_macb <= add16;
                 end
         3'b010: begin
                    cof_reg_maca <= cof3;
                    add_reg_macb <= add25;
                 end
         3'b011: begin
                    cof_reg_maca <= cof4;
                    add_reg_macb <= add34;
                 end
         default: begin
                    cof_reg_maca <= 12'b0;
                    add_reg_macb <= 13'b0;
                 end           
      endcase
end

//调用XILINX公司的乘法器IPcore
mult mult1(.clk(clk),
           .a(cof_reg_maca),    
           .b(add_reg_macb),
           .q(result));

wire [OUT_WIDTH-1 : 0] result_out = {{3{result[23]}},result};

always @ (posedge clk or negedge rst_n) begin
   if(!rst_n)
      sum <= 27'b0;
   else
      if(count==3'b000)
         sum <= 27'b0;
      else
         sum <= sum + result_out;
end

always @ (posedge clk or negedge rst_n) begin
   if(!rst_n)
      fir_out <= 27'b0;
   else
      if(count==3'b000)
         fir_out <= sum;
end

endmodule
