`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:32:30 08/19/2007 
// Design Name: 
// Module Name:    rs_enc 
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
module rs_enc(clk, reset, x, y);
input clk;
input reset;
input [3:0] x;
output [3:0] y;

reg [3:0] cnt;
reg [3:0] D1, x_in;

always @(posedge clk) begin
	 if(reset) begin
	    cnt <= 4'b1001;
		 D1 <= 0;
		 x_in <= 0;
	 end
	 else begin
	 		if(cnt == 4'b1001) //计数器到9，总共有10个状态
	 			cnt <= 0;
	 		else
	 		   cnt <= cnt + 1;	
			if(cnt == 4'b0000) begin
				D1 <= 0;
				x_in <= 0;
			end
			else begin
            D1[3] <= x_in[2] ^ x_in[1] ^ x_in[3];	
            D1[2] <= x_in[3] ^ x_in[1] ^ x_in[0] ^ x_in[2];
				D1[1] <= x_in[2] ^ x_in[0] ^ x_in[1];	
            D1[0] <= x_in[3] ^ x_in[2] ^ x_in[0];	
				x_in <= D1 ^ x;
			end				
	end
end	

assign y = (cnt == 4'b1000) ? D1 : (cnt == 4'b1001) ? x_in : x;


endmodule
