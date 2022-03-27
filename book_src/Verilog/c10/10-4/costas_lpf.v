`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:50:43 08/09/2007 
// Design Name: 
// Module Name:    costas_lpf 
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
module costas_lpf(CLK, RESET, DIN, DOUT);
input CLK;
input RESET;
input [15:0] DIN;
output [15:0] DOUT;

wire [35:0] dout_t;
fir_lpf fir_lpf(
   .CLK(CLK),
   .RESET(RESET),
   .ND(!RESET),
   .DIN(DIN),
   .DOUT(dout_t)
   ); 
	
assign DOUT = dout_t[35:20];

endmodule
