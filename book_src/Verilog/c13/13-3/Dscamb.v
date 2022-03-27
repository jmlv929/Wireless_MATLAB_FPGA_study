`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:38:47 10/04/2007 
// Design Name: 
// Module Name:    Dscamb 
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
module Dscamb(clk, reset, scambI, scambQ, I, Q);
input clk, reset;
input [17: 0] scambI, scambQ;
output I, Q;

reg I, Q;
integer i;
reg [18:0] scamI, scamQ;

always @(posedge clk) begin
   if(!reset) begin
		scamI[17:0] = scambI;
		scamQ[17:0] = scambQ;
      i = 0;
   end
	else begin
		if(i<38400) begin
			I = scamI[0] + scamQ[0];
			Q = (scamI[4] + scamI[6]+ scamI[15]) + (scamQ[5]+ scamQ[6] + 
			    scamQ[8]+ scamQ[9] + scamQ[10] + scamQ[11] + scamQ[12]+ 
				 scamQ[13] + scamQ[14] + scamQ[15]) ;
			scamI[18] = scamI[0] + scamI[7];
			scamQ[18] = scamQ [0] + scamQ[5] + scamQ[7] + scamQ[10];
			scamI = scamI>>1;
			scamQ = scamQ>>1;
			i = i + 1;
	end
	else
			i = 0;
	end
end

endmodule
