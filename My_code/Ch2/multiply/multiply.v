`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/28 11:42:28
// Design Name: 
// Module Name: multiply
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module multiply(
    input clk,
    input CE,
    input SCLR,
    input[15:0] A,
    input[15:0] B,
    input[3:0] C,
    input SUBTRACT,
    output[47:0] P,
    output[47:0] PCOUT
    );

xbip_multadd_0 xbip_multadd_inst0(
  .CLK(clk),            // input wire CLK
  .CE(CE),              // input wire CE
  .SCLR(SCLR),          // input wire SCLR
  .A(A),                // input wire [15 : 0] A  unsigned
  .B(B),                // input wire [15 : 0] B    unsigned
  .C(C),                // input wire [3 : 0] C   unsigned
  .SUBTRACT(SUBTRACT),  // input wire SUBTRACT
  .P(P),                // output wire [47 : 0] P
  .PCOUT(PCOUT)        // output wire [47 : 0] PCOUT
);

endmodule
