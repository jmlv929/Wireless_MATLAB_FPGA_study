`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:37:26 07/20/2007 
// Design Name: 
// Module Name:    two_ASK 
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
module two_ASK(clk, reset, x, y);
input clk;
input reset;
input x; //输入信号
output y;



// cnt 是分频计数器
reg  cnt;
// carriers是要调制的载波信号,将输入信号clk经过4分频得到
reg carriers;

always @(posedge clk) begin
  if(!reset) begin
    cnt <= 1'b0;
    carriers <= 0;
  end
  else begin
    if (cnt == 1'b1) begin
       cnt <= 1'b0;
       carriers <= ~carriers;
    end
    else begin
       carriers <= carriers;
       cnt <= cnt + 1;
    end
  end
end

// 对基带信号进行调制
assign y = x & carriers;

endmodule
