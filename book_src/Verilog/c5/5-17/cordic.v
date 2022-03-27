`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:39:47 09/21/2007 
// Design Name: 
// Module Name:    cordic 
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
module cordic(clk,rst_n,ena,phase_in,sin_out,cos_out,eps);

parameter DATA_WIDTH=8;
parameter PIPELINE=8;

input clk;
input rst_n;
input ena;
input [DATA_WIDTH-1:0] phase_in;

output [DATA_WIDTH-1:0] sin_out;
output [DATA_WIDTH-1:0] cos_out;
output [DATA_WIDTH-1:0] eps;

reg [DATA_WIDTH-1:0] sin_out;
reg [DATA_WIDTH-1:0] cos_out;
reg [DATA_WIDTH-1:0] eps;

reg  [DATA_WIDTH-1:0] phase_in_reg;

reg  [DATA_WIDTH-1:0] x0,y0,z0;
reg  [DATA_WIDTH-1:0] x1,y1,z1;
reg  [DATA_WIDTH-1:0] x2,y2,z2;
reg  [DATA_WIDTH-1:0] x3,y3,z3;
reg  [DATA_WIDTH-1:0] x4,y4,z4;
reg  [DATA_WIDTH-1:0] x5,y5,z5;
reg  [DATA_WIDTH-1:0] x6,y6,z6;
reg  [DATA_WIDTH-1:0] x7,y7,z7;

reg [1:0] quadrant[PIPELINE:0];
integer i;
//get real quadrant and map to first_n quadrant

always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      phase_in_reg<=8'b0000_0000;
   else
      if(ena)
         begin
            case(phase_in[7:6])
               2'b00:phase_in_reg<=phase_in;
               2'b01:phase_in_reg<=phase_in - 8'h40;  //-pi/2
               2'b10:phase_in_reg<=phase_in - 8'h80;  //-pi
               2'b11:phase_in_reg<=phase_in - 8'hc0;  //-3pi/2
               default:;
            endcase
         end
end

always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x0<=8'b0000_0000;
         y0<=8'b0000_0000;
         z0<=8'b0000_0000;
      end
   else
      if(ena)
         begin
            x0 <= 8'h4D;
//define aggregate constant Xi=1/P=1/1.6467=0.69725(Xi=2^7*P=8'h4D)
            y0 <= 8'h00; 
            z0 <= phase_in_reg; 
         end
end

//level 1
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x1<=8'b0000_0000;
         y1<=8'b0000_0000;
         z1<=8'b0000_0000;
      end
   else
      if(ena)
         if(z0[7]==1'b0)
            begin
               x1 <= x0 - y0;
               y1 <= y0 + x0;
               z1 <= z0 - 8'h20;  //45deg
            end
         else
            begin
               x1 <= x0 + y0;
               y1 <= y0 - x0;
               z1 <= z0 + 8'h20;  //45deg
            end
end

//level2
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x2<=8'b0000_0000;
         y2<=8'b0000_0000;
         z2<=8'b0000_0000;
      end
   else
      if(ena)
         if(z1[7]==1'b0)
            begin
               x2 <= x1 - {y1[DATA_WIDTH-1],y1[DATA_WIDTH-1:1]};
               y2 <= y1 + {x1[DATA_WIDTH-1],x1[DATA_WIDTH-1:1]};
               z2 <= z1 - 8'h12;  //26deg
            end
         else
            begin
               x2 <= x1 + {y1[DATA_WIDTH-1],y1[DATA_WIDTH-1:1]};
               y2 <= y1 - {x1[DATA_WIDTH-1],x1[DATA_WIDTH-1:1]};
               z2 <= z1 + 8'h12;  //26deg
            end
end

//level3
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x3<=8'b0000_0000;
         y3<=8'b0000_0000;
         z3<=8'b0000_0000;
      end
   else
      if(ena)
         if(z2[7]==1'b0)
            begin
               x3 <= x2 - {{2{y2[DATA_WIDTH-1]}},y2[DATA_WIDTH-1:2]};
               y3 <= y2 + {{2{x2[DATA_WIDTH-1]}},x2[DATA_WIDTH-1:2]};
               z3 <= z2 - 8'h09;  //14deg
            end
         else
            begin
              x3 <= x2 + {{2{y2[DATA_WIDTH-1]}},y2[DATA_WIDTH-1:2]};
              y3 <= y2 - {{2{x2[DATA_WIDTH-1]}},x2[DATA_WIDTH-1:2]};
              z3 <= z2 + 8'h09;  //14deg
            end
end            
  
//level4
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x4<=8'b0000_0000;
         y4<=8'b0000_0000;
         z4<=8'b0000_0000;
      end
   else
      if(ena)
         if(z3[7]==1'b0)
            begin
               x4 <= x3 - {{3{y3[DATA_WIDTH-1]}},y3[DATA_WIDTH-1:3]};
               y4 <= y3 + {{3{x3[DATA_WIDTH-1]}},x3[DATA_WIDTH-1:3]};
               z4 <= z3 - 8'h04;  //7deg
            end
         else
            begin
               x4 <= x3 + {{3{y3[DATA_WIDTH-1]}},y3[DATA_WIDTH-1:3]};
               y4 <= y3 - {{3{x3[DATA_WIDTH-1]}},x3[DATA_WIDTH-1:3]};
               z4 <= z3 + 8'h04;  //7deg
            end
end 

//level5
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x5<=8'b0000_0000;
         y5<=8'b0000_0000;
         z5<=8'b0000_0000;
      end
   else
      if(ena)
         if(z4[7]==1'b0)
            begin
               x5 <= x4 - {{4{y4[DATA_WIDTH-1]}},y4[DATA_WIDTH-1:4]};
               y5 <= y4 + {{4{x4[DATA_WIDTH-1]}},x4[DATA_WIDTH-1:4]};
               z5 <= z4 - 8'h02;  //4deg
            end
         else
            begin
               x5 <= x4 + {{4{y4[DATA_WIDTH-1]}},y4[DATA_WIDTH-1:4]};
               y5 <= y4 - {{4{x4[DATA_WIDTH-1]}},x4[DATA_WIDTH-1:4]};
               z5 <= z4 + 8'h02;  //4deg
            end
end 

//level6
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         x6<=8'b0000_0000;
         y6<=8'b0000_0000;
         z6<=8'b0000_0000;
      end
   else
      if(ena)
         if(z5[7]==1'b0)
            begin
               x6 <= x5 - {{5{y5[DATA_WIDTH-1]}},y5[DATA_WIDTH-1:5]};
               y6 <= y5 + {{5{x5[DATA_WIDTH-1]}},x5[DATA_WIDTH-1:5]};
               z6 <= z5 - 8'h01;  //2deg
            end
         else
            begin
               x6 <= x5 + {{5{y5[DATA_WIDTH-1]}},y5[DATA_WIDTH-1:5]};
               y6 <= y5 - {{5{x5[DATA_WIDTH-1]}},x5[DATA_WIDTH-1:5]};
               z6 <= z5 + 8'h01;  //2deg
            end
end 

//remain the quadrant information for 'duiqi'
always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      for(i=0; i<=PIPELINE; i=i+1)
         quadrant[i]<=2'b00;
   else
      if(ena)
         begin
            for(i=0; i<PIPELINE; i=i+1)
               quadrant[i+1]<=quadrant[i];
               quadrant[0]<=phase_in[7:6];
         end
end

always @(posedge clk or negedge rst_n)
begin
   if(!rst_n)
      begin
         sin_out <= 8'b0000_0000;
         cos_out <= 8'b0000_0000;
         eps <= 8'b0000_0000;
      end
   else
      if(ena)
         case(quadrant[7])
            2'b00:begin
                     sin_out <= y6; 
                     cos_out <= x6;
                     eps <= z6;
                  end
            2'b01:begin
                     sin_out <= x6; 
                     cos_out <= ~(y6) + 1'b1;
                     eps <= z6;
                  end
            2'b10:begin
                     sin_out <= ~(y6) + 1'b1; 
                     cos_out <= ~(x6) + 1'b1;
                     eps <= z6;
                  end
            2'b11:begin
                     sin_out <= ~(x6) + 1'b1; 
                     cos_out <= y6;
                     eps <= z6;
                  end
         endcase
end

endmodule

