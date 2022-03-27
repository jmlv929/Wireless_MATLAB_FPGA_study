`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:19:18 08/12/2007 
// Design Name: 
// Module Name:    lineardecode 
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
module lineardecode(reset, y, c);
input reset;
input [6:0] y;
output [6:0] c;

wire [2:0] s;
reg  [6:0] e;

assign s[0] = reset ? 0 : (y[5] ^ y[4] ^ y[3] ^y[0]);
assign s[1] = reset ? 0 : (y[6] ^ y[5] ^ y[4] ^y[1]);
assign s[2] = reset ? 0 : (y[6] ^ y[5] ^ y[3] ^y[2]);

always @(s[2:0] or reset) begin
	if(reset) 
		e = 0;
	else
	   case(s[2:0]) 
		  3'b000: e = 7'b0000_000;
		  3'b001: e = 7'b0000_001;
		  3'b010: e = 7'b0000_010;
		  3'b011: e = 7'b0000_100;
		  3'b100: e = 7'b0001_000;
		  3'b101: e = 7'b0010_000;
		  3'b110: e = 7'b0100_000;
		  3'b111: e = 7'b1000_000;	
        default: e = 7'b0000_000;		  
		endcase
end

assign c = reset ? 0 : y ^ e;

endmodule
