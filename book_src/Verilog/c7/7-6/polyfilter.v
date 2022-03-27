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
  
  input          clk;          	// �����źŵ�����
  input         clk2;         	// �����źŵ����ʵ�һ��
  input          reset;
  input  [7:0]    x_in;         	// �����ź�
  output [8:0]    y_out;          	// ����ź�

 // �����м�Ĵ���������ϵ���Լ��˷������������
  reg  [16:0] m0, m1, m2, m3, r0, r1, r2, r3; 
  reg  [16:0] x33, x99, x107;
  reg  [16:0] y;
  reg  [7:0] x_odd, x_even, x_wait;   // ����ֽ�Ŀ����桢ż�ź�
  wire [16:0] x_odd_sxt, x_even_sxt;
  reg   state; 

  always @(posedge clk)  begin 	// �����桢ż�ֿ�
    if(!reset) begin //��ʼ���Ĵ���
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

  always @(posedge clk)  begin // ����˲�
    if(!reset) begin
	    x33  = 0;   //��ʼ���Ĵ���         
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
		 // �����˲����
		 m0 = (x_even_sxt << 7) - (x_even_sxt << 2); // m0 = 124
		 m1 = x107 << 1; // m1 = 214
		 m2 = (x_even_sxt << 6) - (x_even_sxt << 3)  + x_even_sxt;// m2 =  57
		 m3 = x33; // m3 = -33
	 end
  end

  always @(negedge clk2) begin //�ο��Ĵ���
     if(!reset) begin
	     r0 <= 0;
		  r2 <= 0;
		  r1 <= 0;
		  r3 <= 0;
	  end
	  else begin
	    //�����˲���G0             
		 r0 <=  r2 + m0;        // g0 = 128
		 r2 <=  m2;             // g2 = 57
	    //�����˲��� G1
		 r1 <=  -r3 + m1;       // g1 = 214
		 r3 <=  m3;             // g3 = -33
	    // ��������ź�
		 y <= r0 + r1; 
	  end
  end
  
  assign y_out = y[16:8]; //�������źŸ�ֵ

endmodule

