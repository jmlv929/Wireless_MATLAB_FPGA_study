`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:39:20 10/04/2007 
// Design Name: 
// Module Name:    ovsf 
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
module ovsf(clk, reset, SF, K, code);
input clk;
input reset; 
input [2:0] SF; //输入SF的编码号
input [8:0] K;   //K为码字编号
output code;   //cnt为一个模为扩频因子的同步计数器

reg [8:0] cnt;
wire [8:0] dsf;
assign dsf = (SF==3'b000)? 3:(SF==3'b001)? 7: (SF==3'b010)? 15:(SF==3'b011)? 
             31: (SF==3'b100)? 63: (SF==3'b101)? 127:(SF==3'b110) ? 255: 511;

always @(posedge clk) begin
   if(!reset) 
	   cnt <= dsf;
	else
	   if(cnt == dsf)
		   cnt <= 0;
		else
		   cnt <= cnt + 1;
end

wire [8:0] k_tmp;
assign k_tmp = (SF==3'b000)? {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,K[0],K[1]}:
               (SF==3'b001)? {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,K[0],K[1],K[2]}:
					(SF==3'b010)? {1'b0,1'b0,1'b0,1'b0,1'b0,K[0],K[1],K[2],K[3]}:
					(SF==3'b011)? {1'b0,1'b0,1'b0,1'b0,K[0],K[1],K[2],K[3],K[4]}:
					(SF==3'b100)? {1'b0,1'b0,1'b0,K[0],K[1],K[2],K[3],K[4],K[5]}:
					(SF==3'b101)? {1'b0,1'b0,K[0],K[1],K[2],K[3],K[4],K[5],K[6]}:
					(SF==3'b110)? {1'b0,K[0],K[1],K[2],K[3],K[4],K[5],K[6],K[7]}:
					{K[0],K[1],K[2],K[3],K[4],K[5],K[6],K[7],K[8]};
					
assign code = ^(k_tmp&cnt);

endmodule
