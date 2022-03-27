`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:36:39 09/18/2007 
// Design Name: 
// Module Name:    polyfilter 
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
module polyfilter (clk, clk2, reset, x_in,  y_out);
  parameter even=0, odd=1;
  
  input          clk;          	// 输入信号的速率
  input         clk2;         	// 输入信号的速率的一半
  input          reset;
  input  [7:0]    x_in;         	// 输入信号
  output [8:0]    y_out;          	// 输出信号

 // 各种中间寄存器，包括系数以及乘法器的输入参数
  reg  [16:0] m0, m1, m2, m3, r0, r1, r2, r3; 
  reg  [16:0] x33, x99, x107;
  reg  [16:0] y;
  reg  [7:0] x_odd, x_even, x_wait;   // 多相分解的开的奇、偶信号
  wire [16:0] x_odd_sxt, x_even_sxt;
  reg   state; 

  always @(posedge clk)  begin 	// 按照奇、偶分开
    if(!reset) begin //初始化寄存器
	    state <= even;
		 x_even <= 0;
		 x_odd <= 0;
		 
	 end
	 else begin 
		 case (state) 
			even : begin
			  x_even <= x_in; 
			  x_odd  <= x_wait;
			  state <= odd;
			end
			odd : begin
			  x_wait <= x_in;
			  state <= even;
			end
		 endcase  
	  end
  end

  assign x_odd_sxt = {{9{x_odd[7]}},x_odd};
  assign x_even_sxt = {{9{x_even[7]}},x_even};

  always @(posedge clk)  begin // 完成滤波
    if(!reset) begin
	    x33  = 0;   //初始化寄存器         
		 x99  = 0;                  
		 x107 = 0;
		 m0 = 0; 
		 m1 = 0; 
		 m2 = 0;
		 m3 = 0; 
	 end
	 else begin
		 x33  = (x_odd_sxt << 5) + x_odd_sxt;            
		 x99  = (x33 << 1) + x33;                  
		 x107 = x99 + (x_odd_sxt << 3);
		 // 计算滤波输出
		 m0 = (x_even_sxt << 7) - (x_even_sxt << 2); // m0 = 124
		 m1 = x107 << 1; // m1 = 214
		 m2 = (x_even_sxt << 6) - (x_even_sxt << 3)  + x_even_sxt;// m2 =  57
		 m3 = x33; // m3 = -33
	 end
  end

  always @(negedge clk2) begin //参考寄存器
     if(!reset) begin
	     r0 <= 0;
		  r2 <= 0;
		  r1 <= 0;
		  r3 <= 0;
	  end
	  else begin
	    //计算滤波器G0             
		 r0 <=  r2 + m0;        // g0 = 128
		 r2 <=  m2;             // g2 = 57
	    //计算滤波器 G1
		 r1 <=  -r3 + m1;       // g1 = 214
		 r3 <=  m3;             // g3 = -33
	    // 多相输出信号
		 y <= r0 + r1; 
	  end
  end
  
  assign y_out = y[16:8]; //完成输出信号赋值

endmodule

