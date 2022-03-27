`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:43:26 09/09/2007 
// Design Name: 
// Module Name:    cmultip 
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
module cmultip(clk, ar, ai, qr, br, bi, qi);
  input clk;
  input [15 : 0] ar;
  input [15 : 0] br;
  output [31 : 0] qr;
  input [15 : 0] ai;
  input [15 : 0] bi;
  output [31 : 0] qi; 
 
  wire [15 : 0] br_add_bi;
  wire [15 : 0] ar_add_ai;
  wire [15 : 0] ai_sub_br;
  
  wire [31 : 0] arbrbiout;
  wire [31 : 0] araibiout;
  wire [31 : 0] aiarbrout;
  
  //完成加法预处理
  assign    br_add_bi = br + bi; 
  assign    ar_add_ai = ar + ai;
  assign    ai_sub_br = ai - ar;
  
  //调用乘法器模块
  rmulti rmulti1(.clk(clk), .a(ar), .b(br_add_bi), .p(arbrbiout));
  rmulti rmulti2(.clk(clk), .a(bi), .b(ar_add_ai), .p(araibiout));
  rmulti rmulti3(.clk(clk), .a(br), .b(ai_sub_br), .p(aiarbrout));
  
  assign qr = arbrbiout - araibiout;
  assign qi = arbrbiout + aiarbrout;

endmodule

