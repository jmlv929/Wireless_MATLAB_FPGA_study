`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:06:45 09/12/2007 
// Design Name: 
// Module Name:    divf16_1 
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
module divf16_1 (clk, dividend_mantissa, dividend_sign, dividend_exponent, 
divisor_mantissa, divisor_sign, divisor_exponent, quotient_mantissa, 
quotient_sign, quotient_exponent, overflow, underflow);

input clk;
input [7 : 0] dividend_mantissa;
input dividend_sign;
input [7 : 0] dividend_exponent;
input [7 : 0] divisor_mantissa;
input divisor_sign;
input [7 : 0] divisor_exponent;
output [7 : 0] quotient_mantissa;
output quotient_sign;
output [7 : 0] quotient_exponent;
output overflow;
output underflow;

divf16 divf16_1(.clk(clk), .dividend_mantissa(dividend_mantissa), 
.dividend_sign(dividend_sign), .dividend_exponent(dividend_exponent), 
.divisor_mantissa(divisor_mantissa), .divisor_sign(divisor_sign),
.divisor_exponent(divisor_exponent),
.quotient_mantissa(quotient_mantissa),
.quotient_sign(quotient_sign), .quotient_exponent(quotient_exponent),
.overflow(overflow), .underflow(underflow));

endmodule

