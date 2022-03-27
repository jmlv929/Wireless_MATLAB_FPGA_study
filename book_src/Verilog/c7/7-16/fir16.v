`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:14:17 09/19/2007 
// Design Name: 
// Module Name:    fir16 
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
module fir16(clk_30p72MHz, reset, x_in, y_out);
input clk_30p72MHz;
input reset;
input [15:0] x_in;
output [15:0] y_out;

wire rdy;
wire rdf;

//调用MAC fir,其中输入数据速率为3.84Mbps，系统工作时钟为30.72MHz
sender_fir sender_fir(
   .CLK(clk_30p72MHz),
   .RESET(!reset),
   .ND(reset),
   .DIN(x_in),
   .RDY(rdy),
   .RFD(rdf),
   .DOUT(y_out));

endmodule
