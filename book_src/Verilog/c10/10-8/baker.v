`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:05:17 09/24/2007 
// Design Name: 
// Module Name:    baker 
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
module Barker(clk,reset,DataIn,DataOut);
	parameter length  = 12;
	parameter sumlen  = 15;
		
	input  [length-1:0]    DataIn; //来自Rake接收模块的帧解扩数据         
   input  clk; //时钟信号
	input  reset;                 //复位信号    	                        
	output [sumlen-1:0]    DataOut;  //巴克码相关值
     
	reg    [sumlen-1:0]    DataOut; 
	reg    [sumlen-1:0]    tempCor;
   reg    [2:0]           cnt;
	
   always @(posedge clk)begin    
      if(!reset) begin
		     tempCor <= 0;
			  cnt <= 0;	
      end			  
		else begin				    
           if(cnt == 6)
              cnt <= 0;
           else
			    cnt <= cnt + 1; 
           case(cnt)
			    //7位巴克码依次为1 1 1 -1 -1 1 -1
             3'b000: begin 
				         tempCor[14:0] <= {{3{DataIn[11]}}, DataIn[11:0]};
							DataOut <= tempCor[14:0];
				 end
				 3'b001: tempCor[14:0] <= tempCor[14:0] + {{3{DataIn[11]}}, DataIn[11:0]};
             3'b010: tempCor[14:0] <= tempCor[14:0] + {{3{DataIn[11]}}, DataIn[11:0]};
				 3'b011: tempCor[14:0] <= tempCor[14:0] - {{3{DataIn[11]}}, DataIn[11:0]};
             3'b100: tempCor[14:0] <= tempCor[14:0] - {{3{DataIn[11]}}, DataIn[11:0]};
				 3'b101: tempCor[14:0] <= tempCor[14:0] + {{3{DataIn[11]}}, DataIn[11:0]};
             3'b110: tempCor[14:0] <= tempCor[14:0] - {{3{DataIn[11]}}, DataIn[11:0]};
				 default: tempCor[14:0] <= {{3{DataIn[11]}}, DataIn[11:0]};			 
           endcase			  
	   end
   end		

endmodule	