`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:50:06 09/21/2007 
// Design Name: 
// Module Name:    rcf16 
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
module rcf16(clk_3p84MHz, clk_61p44MHz, reset, we, x_in, coeff, y_out);
input clk_3p84MHz;
input clk_61p44MHz;
input reset;
input we;
input [15:0] x_in;
input [15:0] coeff;
output [15:0] y_out;

reg [255:0] x_array;
reg [255:0] coeff_array; 
reg [3:0] cnt, i;
reg [15:0] a, b, y_out;
reg FD;
wire [36:0] Q;
wire RDY, ND;
assign ND = 1'b1;

//完成系数更新模块和输入数据移位操作
always @(posedge clk_3p84MHz) begin
   if(!reset) begin
	   x_array <= 0;
		coeff_array <= 0;
	end
	else begin
	   if(we == 1)
		   coeff_array[127:0] <= {coeff_array[111:0], coeff};
		else
		   coeff_array <= coeff_array;
		x_array[255:0] <= {x_array[240:0], x_in};
	end
end

always @(posedge clk_61p44MHz) begin
   if(!reset) begin
	   y_out <= 0;
		cnt <= 0;
	end
	else begin
	   cnt <= cnt + 1;
		if(cnt == 0)
		   FD <= 1;
		else
		   FD <= 0;
	   if(RDY == 1)
		   y_out <= Q[15:0];
		else
		   y_out <= y_out;
		case(cnt) //进行乘加模块的复用
		   4'b0000: begin
				a <= coeff_array[15:0];
				b <= x_array[15:0];			
			end
		   4'b0001: begin
				a <= coeff_array[31:16];
				b <= x_array[31:16];			
			end
		   4'b0010: begin
				a <= coeff_array[47:32];
				b <= x_array[47:32];			
			end
		   4'b0011: begin
				a <= coeff_array[63:48];
				b <= x_array[63:48];			
			end
		   4'b0100: begin
				a <= coeff_array[79:64];
				b <= x_array[79:64];			
			end
		   4'b0101: begin
				a <= coeff_array[95:80];
				b <= x_array[95:80];			
			end
		   4'b0110: begin
				a <= coeff_array[111:96];
				b <= x_array[111:96];			
			end
		   4'b0111: begin
				a <= coeff_array[127:112];
				b <= x_array[127:112];			
			end
		   4'b1000: begin
				a <= coeff_array[143:128];
				b <= x_array[143:128];			
			end
		   4'b1001: begin
				a <= coeff_array[159:144];
				b <= x_array[159:144];			
			end
		   4'b1010: begin
				a <= coeff_array[175:160];
				b <= x_array[175:160];			
			end
		   4'b1011: begin
				a <= coeff_array[191:176];
				b <= x_array[191:176];			
			end
		   4'b1100: begin
				a <= coeff_array[207:192];
				b <= x_array[207:192];			
			end
		   4'b1101: begin
				a <= coeff_array[223:208];
				b <= x_array[223:208];			
			end
		   4'b1110: begin
				a <= coeff_array[239:224];
				b <= x_array[239:224];			
			end
		   4'b1111: begin
				a <= coeff_array[255:240];
				b <= x_array[255:240];			
			end			
		endcase		
	end
end

//调用乘加器的IP core mac,配置成累加16次
rcf_dsp48 rcf_dsp48( 
   .A(a),
   .B(b),
   .CLK(clk_61p44MHz),
   .FD(FD),
   .ND(ND),
   .Q(Q),
   .RDY(RDY)); 

endmodule
