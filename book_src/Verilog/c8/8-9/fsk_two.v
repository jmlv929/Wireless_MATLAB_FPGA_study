`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:41:01 07/22/2007 
// Design Name: 
// Module Name:    fsk_two 
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
module fsk_two(clk, reset, x, y);
input clk;       //系统工作时钟
input reset;     //系统控制信号
input x;         //系统输入信号:2-FSK调制信号
output y;        //解调输出信号

reg y;
// 提供一个判决时刻
reg [4:0] cnt;
// 提供判决计数
reg [2:0] cnt1;
 
always @(posedge clk) begin
  if(!reset)
     cnt <= 5'b00000;
  else
     if(cnt == 5'b10011)
			cnt <= 5'b00000;
	  else
			cnt <= cnt +1;
end

always @(posedge x) begin
  if(!reset) 
	 cnt1 <= 3'b000;
  else
    if(cnt == 5'b00000) begin
		 if(cnt1 > 4) 
			 y <= 0;
		 else
		    y <= 1;
		 cnt1 <= 3'b000;
	 end
	 else
	    cnt1 <= cnt1 + 1;   
end

endmodule
