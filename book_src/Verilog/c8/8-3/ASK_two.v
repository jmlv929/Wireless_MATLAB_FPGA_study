`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:03:03 07/20/2007 
// Design Name: 
// Module Name:    ASK_two 
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
module ASK_two(clk, reset, x, y);
input clk;
input reset;
input x;
output y;

reg y;

reg [2:0] cnt; //计数器
reg [2:0] m;   // 记录x的脉冲数数

always @(posedge clk) begin    //完成cnt的循环计数
  if(!reset) begin
     cnt <= 3'b000;
  end
  else if(cnt == 3'b111)
     cnt <= 3'b000;
  else 
     cnt <= cnt +1 ;
end 

always @(posedge x) begin    // 此过程完成2_ASK信号的解调
  if(!reset) begin
      m <= 3'b000;
  end
  else begin
	if(cnt == 3'b110) begin
		if (m <= 3'b010)          // 只要m计数器超过3，就判决为1
			y <= 1'b0;
		else  
			y <= 1'b1;
		m <= 3'b000; 	 // 清空m计数器
	end
	else
		m <= m+1;
  end
end
endmodule

