`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:11:33 09/23/2007 
// Design Name: 
// Module Name:    hb_filter 
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
module hb_filter(clk_153p6MHz, reset, x_in, y_out);
input clk_153p6MHz;
input reset;
input [15:0] x_in;//其数据速率为30.72MHz
output [15:0] y_out;

reg [1:0] cnt;
reg [3:0] add;
wire [15:0] A_IN;
reg [15:0] B_IN;
reg we, LOAD_IN;
wire [33:0] P_OUT;

//控制DSP48和SRL16模块
always @(posedge clk_153p6MHz) begin
   if(!reset) begin
	   cnt <= 0;
		add <= 0;
		B_IN <= 0;
	end
	else begin
	   if(cnt == 3'b1000)
		  cnt <= 0;
		else 
		  cnt <= cnt + 1;
		case(cnt) //复用dsp48模块
		    3'b000:begin
			   add <= 4'b0001;
				we <= 1;
				B_IN <= -3588;
				LOAD_IN <= 1;
			 end
			 3'b001:begin
			   add <= 4'b0011;
				we <= 0;
				B_IN <= 10466;
				LOAD_IN <= 0;
			 end
			 3'b010: begin
			   add <= 4'b0100;
				we <= 0;
				B_IN <= 16384;
				LOAD_IN <= 0;
			 end
			 3'b011: begin
			   add <= 4'b0101;
				we <= 0;
				B_IN <= 10466;
				LOAD_IN <= 0;
			 end
			 3'b100: begin
			   add <= 4'b0111;
				we <= 0;
				B_IN <= -3588;
				LOAD_IN <= 0;
			 end
			 default: begin
			   add <= 0;
				we <= 0;
				B_IN <= 0;
				LOAD_IN <= 1;
			 end
		endcase
	end
end

assign y_out[15:0] = reset ? P_OUT[33:18] : 0;

//调用基于SRL16的移位寄存器
lut16_core lut16_core(
	 .d(x_in),
	 .spra(add),
	 .clk(clk_153p6MHz),
	 .we(we),
	 .spo(A_IN));

//调用内嵌的dsp48单元
dsp48_core dsp48_core(
    .A_IN(A_IN), 
    .B_IN(B_IN), 
    .CLK_IN(clk_153p6MHz), 
    .LOAD_IN(LOAD_IN), 
    .P_OUT(P_OUT)
    );
	 
endmodule
