`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:41:16 09/12/2007 
// Design Name: 
// Module Name:    divider 
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
module divider(clock,reset,word1,word2,Start,quotient,remainder,Ready,Error);

	parameter L_divn = 8;
	parameter L_divr = 4;
	parameter S_idle = 0, S_Adivr = 1, S_Adivn = 2, S_div = 3, S_Err =4;
	parameter L_state = 3, L_cnt = 4, Max_cnt = L_divn - L_divr;
	
	input [L_divn-1 : 0] word1; //被除数数据通道
	input [L_divr-1 : 0] word2; //除数数据通道
	input Start, clock, reset;
	output [L_divn-1 : 0] quotient; //商
	output [L_divn-1 : 0] remainder; //余数
	output Ready, Error;

	reg [L_state-1 : 0] state, next_state;
	reg Load_words, Subtract, Shift_dividend, Shift_divisor;
	reg quotient;
	reg [L_divn : 0] dividend;  //扩展的被除数
	reg [L_divr-1 : 0] divisor;
	reg [L_cnt-1 : 0] num_shift_dividend, num_shift_divisor;
	reg [L_divr : 0] comparison;
	wire MSB_divr = divisor[L_divr-1];
	wire Ready = ((state == S_idle) && !reset);
	wire Error = (state == S_Err);
	wire Max = (num_shift_dividend== Max_cnt + num_shift_divisor);
	wire sign_bit = comparison[L_divr];

	always@(state or dividend or divisor or MSB_divr) begin //从被除数中减去除数
			case(state)
				S_Adivr: if(MSB_divr == 0) 
							comparison = dividend[L_divn : L_divn - L_divr] + 
											{1'b1, ~(divisor << 1)} + 1'b1;
							else 
							comparison = dividend[L_divn : L_divn - L_divr] + 
											{1'b1, ~divisor[L_divr-1 : 0]} + 1'b1;
				default: comparison = dividend[L_divn : L_divn - L_divr] + 
											{1'b1, ~divisor[L_divr-1 : 0]} + 1'b1;
			endcase
	end

	//将余数移位来对应于整体的移位
	assign remainder = (dividend[L_divn-1 : L_divn-L_divr]) > num_shift_divisor;
	
	always@(posedge clock) begin
	   if(reset) 
		   state <= S_idle;
	   else
		   state <= next_state;
   end

	//次态与控制逻辑
	always@(state or word1 or word2 or state or comparison or sign_bit or Max) begin
			Load_words = 0; 
			Shift_dividend = 0; 
			Shift_divisor = 0; 
			Subtract = 0;
			case(state) 
				 S_idle: case(Start)
					  0: next_state = S_idle;
					  1: if(word2 == 0) 
								 next_state = S_Err;
						  else if(word1) begin
								 next_state = S_Adivr; 
								 Load_words = 1;
						  end
						  else 
						       next_state = S_idle;
					endcase
				 S_Adivr: case(MSB_divr)
					  0: if(sign_bit == 0) begin
								 next_state = S_Adivr; 
								 Shift_divisor = 1;  //可移动除数
						  end
						  else if(sign_bit == 1) begin
								 next_state = S_Adivn;   //不可移动除数
						  end
					  1: next_state = S_div;
					endcase
				S_Adivn: case({Max, sign_bit})
					  2'b00: next_state = S_div;
					  2'b01: begin
								 next_state = S_Adivn; 
								 Shift_dividend = 1;
						  end
					  2'b10: begin
								 next_state = S_idle; 
								 Subtract = 1;
						  end
					  2'b11: next_state = S_idle;
					endcase
				S_div: case({Max, sign_bit})
					  2'b00: begin
								 next_state = S_div; 
								 Subtract = 1;
								end
					  2'b01: next_state = S_Adivn;
					  2'b10: begin
								 next_state = S_div; 
								 Subtract = 1;
								end
					  2'b11: begin
								 next_state = S_div; 
								 Shift_dividend = 1;
							 end
					endcase
		     default: next_state = S_Err;
		 endcase
end

always@(posedge clock)begin  //寄存器,数据通道操作
   if(reset)begin
      divisor <= 0; 
		dividend <= 0; 
		quotient <= 0; 
		num_shift_dividend <= 0; 
		num_shift_divisor <= 0;
   end
   else if(Load_words == 1) begin
      dividend <= word1;
      divisor <= word2;
      quotient <= 0;
      num_shift_dividend <= 0;
      num_shift_divisor <= 0;
   end
   else if(Shift_divisor) begin
      divisor <= divisor << 1;
      num_shift_divisor <= num_shift_divisor + 1;
   end
   else if(Shift_dividend) begin
      dividend <= dividend << 1;
      quotient <= quotient << 1;
      num_shift_dividend <= num_shift_dividend + 1;
   end
   else if(Subtract) begin
      dividend[L_divn : L_divn-L_divr] <= comparison;
      quotient[0] <= 1;
   end
end
	
endmodule
