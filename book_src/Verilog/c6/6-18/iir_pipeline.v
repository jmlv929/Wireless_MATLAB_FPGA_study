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

  parameter W = 14; //WΪ�����λ���1
  input          clk;
  input         reset;
  input  [W:0]  x_in;   // �����ź�
  output [W:0]  y_out;  // �˲�����ź�
  
  // �����м����
  reg [W:0] x, x3, sx;
  reg [W:0] y, y9;  
            
  always @(posedge clk)  begin //��ˮ�߲��� 
    if(!reset) begin
	    x <= 0;
		 x3 <= 0;
		 sx <= 0;
		 y <= 0;
		 y9 <= 0;
	 end
	 else begin
		 x	 <= x_in;  
       //����x / 2 + x / 4 = x*3/4		 
		 x3  <= {x[W],x[W:1]} + {x[W],x[W],x[W:2]}; 
		 //������x���									
		 sx  <= x + x3; 
		 //����y / 2 + y / 16 = y*9/16
		 y9  <= {y[W],y[W:1]} + {{4{y[W]}},y[W:4]}; 
		 //�������
		 y   <= sx + y9;                  
	 end
  end

  assign y_out = y ;   

endmodule

