`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:02:45 08/29/2007
// Design Name:   blockconnect
// Module Name:   C:/work/ISE/c11/test_block_connect.v
// Project Name:  c11
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: blockconnect
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_block_connect_v;

	// Inputs
	reg clk;
	reg reset;
	reg [15:0] x_i;
	reg [15:0] x_q;

	// Outputs
	wire [15:0] y_out_i;
	wire [15:0] y_out_q;

	// Instantiate the Unit Under Test (UUT)
	blockconnect uut (
		.clk(clk), 
		.reset(reset), 
		.x_i(x_i), 
		.x_q(x_q), 
		.y_out_i(y_out_i), 
		.y_out_q(y_out_q)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		x_i = 0;
		x_q = 0;

		// Wait 100 ns for global reset to finish
		#100;
      reset  = 1;
		// Add stimulus here
	end
	
	always #2 clk = !clk;
	always #8 x_i = x_i + 1;
	always #8 x_q = x_q + 1;
      
endmodule

