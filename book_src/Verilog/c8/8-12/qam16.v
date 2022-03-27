`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:51:06 09/18/2007 
// Design Name: 
// Module Name:    qam16 
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
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:55:47 09/16/2007 
// Design Name: 
// Module Name:    qam16 
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
module qam16(clk, clk12p5MHz, reset, x, y);
input clk;
input clk12p5MHz;
input reset;
input x;
output [17:0] y;

reg [1:0] cnt;
reg [3:0] x_t,x_t_1;
reg [16 : 0] csignal;
reg [16 : 0] ssignal;
wire [24 : 0] data;
wire [4 : 0] a;
wire [15 : 0] cosine;
wire [15 : 0] sine;
	
//完成输入比特的寄存用于控制DDS的输出
always @(posedge clk) begin
   if(!reset) begin
		 x_t <= 0;
		 x_t_1 <= 0;
		 cnt <= 0;
	end
	else begin
	   cnt <= cnt + 1;
	   x_t_1[3:0] <= {x_t_1[2:0], x};
		if(cnt == 0)
		  x_t <= x_t_1;
		else 
		  x_t <= x_t;
	end
end

assign a = 0;
assign data = 2684355;

//产生相应的同相和正交信号
always @(posedge clk12p5MHz) begin
   if(!reset) begin
     csignal <= 0;
	  csignal <= 0;
	end
	else begin
	   // 配置dds输出信号的幅度值
		   case(x_t)
		     4'b0000: begin // cos+sin
				 csignal[16] <= cosine[15];
				 csignal[15:0] <= cosine[15:0];
				 ssignal[16] <= sine[15];
				 ssignal[15:0] <= sine[15:0];				 
			  end
		     4'b0001: begin // 2cos+sin
				 csignal[16:1] <= cosine[15:0];
				 csignal[0] <= 0;
				 ssignal[16] <= sine[15];
				 ssignal[15:0] <= sine[15:0];					  
			  end
		     4'b0010: begin // cos+2sin
				 csignal[16] <= cosine[15];
				 csignal[15:0] <= cosine[15:0];
				 ssignal[16:1] <= sine[15:0];
				 ssignal[0] <= 0;			  
			  end
		     4'b0011: begin //2cos+2sin
				 csignal[16:1] <= cosine[15:0];
				 csignal[0] <= 0;
				 ssignal[16:1] <= sine[15:0];
				 ssignal[0] <= 0;				  
			  end
		     4'b0100: begin // -cos+sin
			    //  这里采用了近似操作，即各位取反，得到相应的负值，
				 //  会有1的误差，但相对于17比特数，可以忽略不计。
				 csignal[16] <= !cosine[15];
				 csignal[15:0] <= !cosine[15:0];
				 ssignal[16] <= sine[15];
				 ssignal[15:0] <= sine[15:0];					  
			  end
		     4'b0101: begin // -2cos+sin
				 csignal[16:0] <= !cosine[15:0];
				 csignal[0] <= 0;
				 ssignal[16] <= sine[15];
				 ssignal[15:0] <= sine[15:0];					  
			  end
		     4'b0110: begin// -cos+2sin
				 csignal[16] <= !cosine[15];
				 csignal[15:0] <= !cosine[15:0];
				 ssignal[16:1] <= sine[15:0];
				 ssignal[0] <= 0;				  
			  end
		     4'b0111: begin // -2cos+2sin
				 csignal[16:0] <= !cosine[15:0];
				 csignal[0] <= 0;
				 ssignal[16:1] <= sine[15:0];
				 ssignal[0] <= 0;				  
			  end
		     4'b1000: begin // -cos-sin
				 csignal[16] <= !cosine[15];
				 csignal[15:0] <= !cosine[15:0];
				 ssignal[16] <= !sine[15];
				 ssignal[15:0] <= !sine[15:0];			  
			  end
		     4'b1001: begin // -2cos-sin
				 csignal[16:0] <= !cosine[15:0];
				 csignal[0] <= 0;
				 ssignal[16] <= !sine[15];
				 ssignal[15:0] <= !sine[15:0];					  
			  end
		     4'b1010: begin // -cos-2sin
				 csignal[16] <= !cosine[15];
				 csignal[15:0] <= !cosine[15:0];
				 ssignal[16:1] <= !sine[15:0];
				 ssignal[0] <= 0;				  
			  end
		     4'b1011: begin //-2cos-2sin
				 csignal[16:0] <= !cosine[15:0];
				 csignal[0] <= 0;
				 ssignal[16:1] <= !sine[15:0];
				 ssignal[0] <= 0;					  
			  end
		     4'b1100: begin // cos-sin
				 csignal[16] <= cosine[15];
				 csignal[15:0] <= cosine[15:0];
				 ssignal[16] <= !sine[15];
				 ssignal[15:0] <= !sine[15:0];		  
			  end
		     4'b1101: begin // 2cos-sin
				 csignal[16:0] <= cosine[15:0];
				 csignal[0] <= 0;
				 ssignal[16:1] <= !sine[15:0];
				 ssignal[0] <= 0;				  
			  end	
		     4'b1110: begin // cos-2sin
				 csignal[16] <= cosine[15];
				 csignal[15:0] <= cosine[15:0];
				 ssignal[16:1] <= !sine[15:0];
				 ssignal[0] <= 0;				  
			  end	
		     4'b1111: begin // 2cps-2sin
				 csignal[16:0] <= cosine[15:0];
				 csignal[0] <= 0;
				 ssignal[16:1] <= !sine[15:0];
				 ssignal[0] <= 0;				  
			  end	
           default: begin
				 csignal <= 0;
				 ssignal <= 0;	
           end			  
		 endcase
	end
end

//计算调制输出
assign y = reset ? {csignal[16], csignal} + {ssignal[16], ssignal}:0;

//调用DDS的IPCore,用于产生10MHz的正弦波和余弦波
ddsqam ddsqam(
   .DATA(data),
   .WE(reset),
   .A(a),
   .CLK(clk12p5MHz),
   .CE(reset),
   .SINE(sine),
   .COSINE(cosine)
   );

	
endmodule

