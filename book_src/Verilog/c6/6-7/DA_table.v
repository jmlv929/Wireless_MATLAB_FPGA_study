`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:09:08 09/14/2007 
// Design Name: 
// Module Name:    DA_table 
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
module DA_table(table_in_4b, table_out_12b);

parameter TABLE_WIDTH = 4;
parameter COEFF_WIDTH = 12;

input [TABLE_WIDTH-1 : 0] table_in_4b;
output [COEFF_WIDTH-1 : 0] table_out_12b;
reg [COEFF_WIDTH-1 : 0] table_out_12b;

always @(table_in_4b) begin
	 case(table_in_4b)
	     4'b0000: table_out_12b = 0;
	     4'b0001: table_out_12b = 41;
	     4'b0010: table_out_12b = 132;
	     4'b0011: table_out_12b = 173;
	     4'b0100: table_out_12b = 341;
	     4'b0101: table_out_12b = 382;	
	     4'b0110: table_out_12b = 473;
	     4'b0111: table_out_12b = 514;
	     4'b1000: table_out_12b = 510;	
	     4'b1001: table_out_12b = 551;
	     4'b1010: table_out_12b = 642;
	     4'b1011: table_out_12b = 683;
	     4'b1100: table_out_12b = 851;	
	     4'b1101: table_out_12b = 892;
	     4'b1110: table_out_12b = 983;
	     4'b1111: table_out_12b = 1024;	
	     default: table_out_12b = 0;	     
	 endcase
end

endmodule

