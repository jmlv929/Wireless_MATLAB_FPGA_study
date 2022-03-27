`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:32:48 09/19/2007 
// Design Name: 
// Module Name:    agc 
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
module agc(clk, reset, x_in, power, y_out);

parameter MN = 64250;
input clk;
input reset;
input [15:0] x_in;
output [15:0] y_out;
output [36:0] power;

reg [36:0] x_power, x_power1;
reg [5:0] cnt;
wire [31:0] x_out;

always @(clk) begin
   if(!reset) begin
	   x_power <= 0;
	   x_power1 <= 0;
		cnt <= 0;
	end
	else begin
	   cnt <= cnt + 1;
		if(cnt == 0) begin
		  x_power1 <= {{5{x_out[31]}},x_out};
		  x_power <= x_power1;
		end
		else
		  //累加64次求信号的功率
		  x_power1 <= x_power1 + {{5{x_out[31]}},x_out};
	end
end 

// 根据功率值来调整
assign y_out = (x_power <MN) ? (x_in <<1) : (x_in>>1);
assign power =x_power;
//计算每个样值的平方,用于累加求功率
mymult mymult(
  .clk(clk), 
  .a(x_in), 
  .b(x_in), 
  .q(x_out)
);

endmodule
