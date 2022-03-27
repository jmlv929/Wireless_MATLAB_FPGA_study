`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:15:32 08/12/2007 
// Design Name: 
// Module Name:    interleaver 
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
module interleaver(clk, reset, x, y);
input clk; //clk和x同频同相 
input reset;
input [15:0] x;
output [15:0] y;

reg [7:0] addra, addrb; //RAM的控制地址
wire [7:0] addrat, addrbt;
reg [3:0] cnt,addr0;
always @(posedge clk) begin
	if(!reset) begin
		addra <= 0;
		addrb <= 0;
		cnt <= 0;
	end
	else begin
	   if(addra == 191) //顺序依次将x写入BLOCK RAM
			addra <= 0;
      else
	      addra <= addra + 1; 
		if (addrb > 175) begin
		    addrb <= addr0;
		    if(cnt == 11)
			   cnt <= 0;
			 else
			   cnt <= cnt + 1;
		end
      else begin
         cnt <= cnt;	
			addrb <= addrb + 16;
		end
	end
end

always @(cnt) begin
		case (cnt)
         4'b0000: addr0 <= 0;
         4'b0001: addr0 <= 1;
         4'b0010: addr0 <= 2;
         4'b0011: addr0 <= 3;
         4'b0100: addr0 <= 4;
         4'b0101: addr0 <= 5;
         4'b0110: addr0 <= 6;
         4'b0111: addr0 <= 7;
         4'b1000: addr0 <= 8;
         4'b1001: addr0 <= 9;
         4'b1010: addr0 <= 10;    
			4'b1011: addr0 <= 11;	
         default: addr0 <= 0;			
      endcase	
end		

block_ram block_ram(
	.addra(addra),
	.addrb(addrb),
	.clka(clk),
	.clkb(clk),
	.dina(x),
	.doutb(y),
	.wea(reset));
	
endmodule
