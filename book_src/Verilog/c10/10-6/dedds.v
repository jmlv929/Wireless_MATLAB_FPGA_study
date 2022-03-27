`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:52:31 09/24/2007 
// Design Name: 
// Module Name:    dedds 
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
module dedds(clk, reset, data, clk_7p68MHz); 
input clk;
input reset;
input [15:0] data;
output clk_7p68MHz;

//相位和频率都是64个时钟调整一次,为了防止溢出，进行了扩位处理
reg [26:0] data_freq, data_phase; 
reg [5:0] cnt;
wire [9:0] cosine;
wire [26:0] dds_data;
wire [4:0] a;
wire we;
always @(posedge clk) begin
   if(!reset) begin
	   //频率的初始值设为7.68M，相位偏置为0
	   data_freq <= 0;
		data_phase <= 0;
		cnt <= 0;
	end
	else begin
	   cnt <= cnt + 1;
	   //频率控制字直接相加
	   data_freq[26:0] <= data_freq[26:0] + {{11{data[15]}}, data[15:0]};
		// 相位控制字经过一定的线性放大
		data_phase[26:0] <= data_phase[26:0] + {{8{data[15]}}, data[15:0], 3'b000};
	end
end

//在cnt=63的时候更新相位控制量，在cnt=31的时候更新频率控制量
assign dds_data = (cnt==31) ? data_freq : (cnt==63) ? data_phase : 0;
assign we = (cnt== 31) ? 1 :(cnt==63) ? 1 : 0;
assign a = (cnt==31) ? 5'b0000 : (cnt==63) ? 5'b10000 : 0;

eddds eddds(
   .DATA(dds_data), .WE(we), .A(a), .CLK(clk), .COSINE(cosine));

//对10位的正弦波进行比较，输出方波
assign clk_7p68MHz = (!reset) ? 0 :(cosine > 0) ? 1 : 0;

endmodule
