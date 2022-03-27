`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:08:02 09/14/2007 
// Design Name: 
// Module Name:    da_fir 
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
module da_fir(clk, reset, fir_in, fir_out);
parameter IDATA_WIDTH = 12;   //输入数据位宽
parameter PDATA_WIDTH = 13;   //处理数据位宽
parameter FIR_TAP = 8;        //fir滤波器抽头数
parameter FIR_TAPHALF = 4;    //fir滤波器的一半抽头数
parameter COEFF_WIDTH = 12;   //系数位宽
parameter OUT_WIDTH = 27;     //输出数据位宽

parameter cof1 = 12'd41;
parameter cof2 = 12'd132;
parameter cof3 = 12'd341;
parameter cof4 = 12'd510;

parameter S0 = 1'b0;    //初始状态
parameter S1 = 1'b1;    //处理状态

input clk;
input reset;
input [IDATA_WIDTH-1:0] fir_in;
output [OUT_WIDTH-1:0] fir_out;

reg [OUT_WIDTH-1:0] fir_out;

reg [IDATA_WIDTH-1:0] fir_in_reg;
reg [PDATA_WIDTH-1:0] shift_buf[FIR_TAP-1:0];   //定义移位寄存器
reg [PDATA_WIDTH-1:0] add_buf[FIR_TAPHALF-1:0]; 

reg [PDATA_WIDTH-1:0] state_shift_buf[FIR_TAPHALF-1:0]; 

wire [3:0] table_4b;    //查表输入

wire [COEFF_WIDTH-1:0] table_out_12b;        //查表输出

reg [OUT_WIDTH-1:0] sum;
reg STATE;

reg [3:0] divfre_count_4b;
reg divfre13_clk;
integer i,j,k,l,m,n,p;

//定义移位寄存器左移的函数delta
function [OUT_WIDTH-1:0] delta;
   input [OUT_WIDTH-1:0] IQ;
   input [3:0] pipe;
      begin
         case(pipe)
            4'b0000: delta = IQ;
            4'b0001: delta = {IQ[OUT_WIDTH-2:0],1'b0};
            4'b0010: delta = {IQ[OUT_WIDTH-3:0],2'b00};
            4'b0011: delta = {IQ[OUT_WIDTH-4:0],3'b000};
            4'b0100: delta = {IQ[OUT_WIDTH-5:0],4'b0000};
            4'b0101: delta = {IQ[OUT_WIDTH-6:0],5'b00000};
            4'b0110: delta = {IQ[OUT_WIDTH-7:0],6'b000000};
            4'b0111: delta = {IQ[OUT_WIDTH-8:0],7'b0000000};
            4'b1000: delta = {IQ[OUT_WIDTH-9:0],8'b00000000};
            4'b1001: delta = {IQ[OUT_WIDTH-10:0],9'b000000000};
            4'b1010: delta = {IQ[OUT_WIDTH-11:0],10'b0000000000};
            4'b1011: delta = {IQ[OUT_WIDTH-12:0],11'b00000000000};
            4'b1100: delta = {IQ[OUT_WIDTH-13:0],12'b000000000000};
            4'b1101: delta = {IQ[OUT_WIDTH-14:0],13'b0000000000000};
            4'b1110: delta = {IQ[OUT_WIDTH-15:0],14'b00000000000000};
            4'b1111: delta = {IQ[OUT_WIDTH-16:0],15'b000000000000000};
            default: delta = IQ;
         endcase
      end
endfunction

always @(posedge clk or negedge reset)
begin
   if(!reset)
      begin
         divfre13_clk <= 1'b0;
         divfre_count_4b <= 4'b0000;
      end
   else
      begin
         if(divfre_count_4b==PDATA_WIDTH)
            begin
               divfre_count_4b <= 4'b0000;
               divfre13_clk <= 1'b1;
            end
         else
            begin
               divfre_count_4b <= divfre_count_4b + 1'b1;
               divfre13_clk <= 1'b0;
            end
      end
end

always @(posedge clk or negedge reset)
begin
   if(!reset)
      fir_in_reg <= 12'b0000_0000_0000;
   else
      if(divfre13_clk)
         fir_in_reg <= fir_in;
end


always @(posedge clk or negedge reset)
begin
   if(!reset)
      for(i=0; i<=FIR_TAP-1; i=i+1)
         shift_buf[i] <= 13'b0000_0000_00000;
   else
      if(divfre13_clk)
      begin
         for(j=0; j<FIR_TAP-1; j=j+1)
            shift_buf[j+1] <= shift_buf[j];
         shift_buf[0] <= {fir_in_reg[IDATA_WIDTH-1],fir_in_reg};    //符号位扩展
      end
end

always @(posedge clk or negedge reset)
begin
   if(!reset)
      for(k=0; k<=FIR_TAPHALF-1; k=k+1)
         add_buf[k] <= 13'b0000_0000_00000;
   else
      if(divfre13_clk)
         for(l=0; l<=FIR_TAPHALF-1; l=l+1)
            add_buf[l] <= shift_buf[l]+shift_buf[FIR_TAP-1-l];
end

//有限状态机的初始化，比特移位
always @(posedge clk or negedge reset)
begin
   if(!reset)
      begin
         for(m=0; m<=FIR_TAPHALF-1; m=m+1)
            state_shift_buf[m] <= 13'b0000_0000_00000;
         STATE <= S0;
      end
   else
      case(STATE)
         S0:begin
               for(n=0; n<=FIR_TAPHALF-1; n=n+1)
                  state_shift_buf[n] <= add_buf[n];
               STATE <= S1;
            end
         S1:begin
               if(divfre_count_4b==4'b1101)
                  STATE <= S0;
               else
                  begin
                     for(p=0; p<=PDATA_WIDTH-2; p=p+1)
                        begin
                           state_shift_buf[0][p] <= state_shift_buf[0][p+1];
                           state_shift_buf[1][p] <= state_shift_buf[1][p+1];
                           state_shift_buf[2][p] <= state_shift_buf[2][p+1];
                           state_shift_buf[3][p] <= state_shift_buf[3][p+1];
                        end
                  STATE <= S1;     
                  end
               end
      endcase
end

assign table_4b[0] = state_shift_buf[0][0];
assign table_4b[1] = state_shift_buf[1][0];
assign table_4b[2] = state_shift_buf[2][0];
assign table_4b[3] = state_shift_buf[3][0];

DA_table U_DA(
              .table_in_4b(table_4b),
              .table_out_12b(table_out_12b)
             );

wire [26:0] sign_ex={table_out_12b[11],table_out_12b[11],table_out_12b[11],table_out_12b[11],table_out_12b[11],table_out_12b[11],table_out_12b[11],table_out_12b[11],table_out_12b[11],table_out_12b[11],table_out_12b[11],table_out_12b[11],table_out_12b[11],table_out_12b[11],table_out_12b[11],table_out_12b};

always @(posedge clk or negedge reset)
begin
   if(!reset)
      sum <= 27'b0;
   else
      if(divfre_count_4b==4'b0000)
         sum <= 27'b0;
      else
         if(divfre_count_4b==4'b1101)
            sum <= sum - delta(sign_ex, divfre_count_4b-4'b0001);
         else
            sum <= sum + delta(sign_ex, divfre_count_4b-4'b0001);
end

always @(posedge clk or negedge reset)
begin
   if(!reset)
      fir_out <= 27'b0;
   else
      if(divfre_count_4b==4'b0000)
         fir_out <= sum;
end

endmodule
