`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:54:56 07/21/2007 
// Design Name: 
// Module Name:    QPSK_two 
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
module QPSK_two(clk, reset, x, y);
input clk;       //系统工作时钟
input reset;     //系统控制信号
input x;         //系统输入信号
output y;        //QPSK解调输出信号

// 先记录下8个时钟周期的信号，然后供下一次判决
reg [7:0] temp; 
reg [7:0] temp2;
reg [2:0] cnt;
wire [1:0] y1;

always @(posedge clk) begin
   if (!reset)
	    cnt <= 3'b111;
	else begin
	    cnt <= cnt +1;
		 if (cnt == 3'b111)
		    temp <= temp2;
		 else
		    temp <= temp;
		 temp2 <= {temp2[6:0], x};	 
   end
end

assign y1 = (reset == 0) ? 2'b00 : 
           (temp == 8'b11110000) ? 2'b00 :
           (temp == 8'b11000011)	? 2'b01 :
           (temp == 8'b00001111)	? 2'b10 :	
           (temp == 8'b00111100)	? 2'b11 : 2'b00;		

assign y = (cnt[2] == 0) ? y1[1] : y1[0];			  

endmodule
