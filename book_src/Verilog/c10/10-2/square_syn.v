`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:39:19 08/06/2007 
// Design Name: 
// Module Name:    square_syn 
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
module square_syn(clk, clk_x, reset, x, y);
    input clk;      // DDS模块的工作时钟
    input clk_x;    // 输入信号的工作时钟
    input reset;    // 模块控制信号
    input [15:0] x;  // 16比特的输入信号
    output [15:0] y; // 16比特的输出信号

parameter c1 = 8; //环路滤波器系数
parameter c2 = 2; 

reg [15:0] y, a, b, lf_t, lf_out;  
reg [31:0] s, lf_d;  //声明中间变量
wire [31:0] q, qx; // q为乘法器的输出, qx为检相器的输出
wire [15:0] y1;    // DDS输出
wire [4:0] add;    // DDS配置通道
wire [27:0] data;  // DDS输入，即相位累加分量
assign add = 5'b00000;
assign qx = q^{y1,16'b0000_0000_0000_0000};

always @(posedge clk_x) begin //控制乘法器的输入
	if(!reset) begin
		a <= 0;
		b <= 0; 	
		s <= 0;
		y <=0;
	end
	else begin
	   a <= x;
		b <= x;
		// 计算环路滤波
		s <= {s[15:0],qx[31:16]}; //取乘法器的高16位
      lf_t[15:0] <= qx[31:16]<<1 + lf_d[31:16];
		lf_d[31:0] <= {lf_d[15:0], lf_t};
		lf_out <= s[31:16]<<3 + lf_t;
		y <= y1; //2分频
	end	
end
	 
// 实例化乘法器的IPcore，其中输入为16比特，输出为32比特。	 
mult mult(  
  .ce(reset),   //时钟信号
  .clk(clk_x),  //乘法器工作时钟
  .a(a),        //两个输
  .b(b), 
  .q(q)         //输出信号
);

// 调用DDS模块
assign data = (!reset) ? 0 : data + lf_out;
mydds mydds(
   .DATA(data),
   .WE(reset),
   .A(add),
   .CLK(clk),
   .SINE(y1)
   );
	
endmodule
