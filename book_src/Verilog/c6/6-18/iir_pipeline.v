`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:32:26 09/17/2007 
// Design Name: 
// Module Name:    iir_pipeline 
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
module iir_pipeline (clk, reset, x_in, y_out); 

  parameter W = 14; //W为处理的位宽减1
  input          clk;
  input         reset;
  input  [W:0]  x_in;   // 输入信号
  output [W:0]  y_out;  // 滤波输出信号
  
  // 声明中间变量
  reg [W:0] x, x3, sx;
  reg [W:0] y, y9;  
            
  always @(posedge clk)  begin //流水线步骤 
    if(!reset) begin
	    x <= 0;
		 x3 <= 0;
		 sx <= 0;
		 y <= 0;
		 y9 <= 0;
	 end
	 else begin
		 x	 <= x_in;  
       //计算x / 2 + x / 4 = x*3/4		 
		 x3  <= {x[W],x[W:1]} + {x[W],x[W],x[W:2]}; 
		 //将变量x求和									
		 sx  <= x + x3; 
		 //计算y / 2 + y / 16 = y*9/16
		 y9  <= {y[W],y[W:1]} + {{4{y[W]}},y[W:4]}; 
		 //计算输出
		 y   <= sx + y9;                  
	 end
  end

  assign y_out = y ;   

endmodule

