`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:36:33 09/17/2007 
// Design Name: 
// Module Name:    iir_par 
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
module iir_par (clk, reset, x_in, clk2, y_out); 

  parameter W = 14; //W为处理的位宽减1
  parameter even=0, odd=1;    
  input          clk;
  input         reset;
  input  [W:0]  x_in;
  output [W:0]  y_out;
  output         clk2;

  reg [W:0] x_even, x_odd, xd_odd, x_wait;
  reg [W:0] y_even, y_odd, y_wait, y;  
//  reg [W:0] x_e, x_o, y_e, y_o;
  reg [W:0] sum_x_even, sum_x_odd;
  reg        clk_div2;
  reg        state;
  
  always @(posedge clk) begin  // 对时钟进行2分频
     if(!reset)
	     clk_div2 <= 0;
	  else
	     clk_div2 <= ! clk_div2;
  end

  always @(posedge clk)  begin 	// 将x分为奇偶采样的样值 
     // 用信号clk对y进行速率转换
	  if(!reset) begin
			state <= even;
			y_wait <= 0;
			x_odd <= 0;
			x_even <= 0;
			x_wait <= 0;
	  end
	  else
		 case (state) 
			even : begin
				 x_even <= x_in; 
				 x_odd <= x_wait;
				 y <= y_wait;
				 state <= odd;
			end
			odd : begin
				x_wait <= x_in;
				y <= y_odd;
				y_wait <= y_even;
				state <= even;
			end
		 endcase
  end

  assign y_out = y;
  assign clk2  = clk_div2;
 
  always @(negedge clk_div2) begin  
    if(!reset) begin
		sum_x_even <= 0;
		sum_x_odd <= 0;
		y_even <= 0;
		y_odd <= 0;
		xd_odd <= 0;
    end
    else begin	 
		 sum_x_even <= x_odd + {x_even[W],x_even[W:1]} 
								  + {x_even[W],x_even[W],x_even[W:2]};
		  // 计算 x_odd + x_even / 2 + x_even /4 
		 y_even <= sum_x_even + {y_even[W],y_even[W:1]} 
										 + {{4{y_even[W]}},y_even[W:4]};
		 // 计算 sum_x_even + y_even / 2 + y_even /16
		 xd_odd <= x_odd;
		 sum_x_odd <= x_even + {xd_odd[W],xd_odd[W:1]} 
								  + {xd_odd[W],xd_odd[W],xd_odd[W:2]};
		 // 计算 x_even + xd_odd / 2 + xd_odd /4
		 y_odd  <= sum_x_odd + {y_odd[W],y_odd[W:1]} 
											+ {{4{y_odd[W]}},y_odd[W:4]};
		 // 计算 sum_x_odd + y_odd / 2 + y_odd / 16
	 end
  end
  
endmodule

