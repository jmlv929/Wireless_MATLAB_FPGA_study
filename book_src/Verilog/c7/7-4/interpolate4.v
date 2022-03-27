`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:32:47 10/09/2007 
// Design Name: 
// Module Name:    interpolate4 
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
module interpolate4(clk, reset, x, y);
input clk;
input reset;
input [7:0]x;
output [7:0]y;

reg [7:0]y;
reg [1:0] cnt;

always @(posedge clk) begin //Íê³ÉÄÚ²å
  if(!reset)
    cnt <= 0;
 else begin
    cnt <= cnt +1;
    if(cnt == 0)
      y<= x;
    else
      y<=0;
 end 
end

endmodule

