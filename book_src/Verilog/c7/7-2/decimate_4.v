`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:23:13 10/09/2007 
// Design Name: 
// Module Name:    decimate_4 
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
module decimate_4(clk, reset, x, y);
input clk;
input reset;
input [7:0] x;
output [7:0] y;

reg [1:0] cnt;
reg [7:0] y;

always @(posedge clk) begin
  if(!reset) 
    cnt <= 0;
  else begin
    cnt <= cnt + 1;
	 if(cnt == 2'b11)
	    y <= x;
	 else
	    y <= y;
  end
end 

endmodule

