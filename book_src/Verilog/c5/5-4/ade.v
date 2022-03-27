`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:41:02 10/08/2007 
// Design Name: 
// Module Name:    ade 
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
module ade (clk, x, y, p); 
    input   clk;
    input   [7:0]  x, y;
    output  [15:0] p;
    reg     [15:0] p;

parameter s0=0, s1=1, s2=2;
    reg [2:0] count;
    reg [1:0] state;
    reg  [15:0] p1, t;        // 比特位加倍
reg  [7:0] y_reg;

    always @(posedge clk) begin
     case (state) 
      s0 : begin         // 初始化
        y_reg <= y;
        state <= s1;
        count = 0;
        p1 <= 0;             
        t <= {{8{x[7]}},x}; 
      end                                         
      s1 : begin          // 处理步骤
        if (count == 7)   //判断是否处理结束
          state <= s2;
        else         
          begin       
          if (y_reg[0] == 1) 
            p1 <= p1 + t;      
          y_reg <= y_reg >> 1;   //移位
          t <= t << 1;
          count = count + 1;
          state <= s1;
        end
      end
      s2 : begin       
        p <= p1;        
        state <= s0;
      end
     endcase  
    end

endmodule
