`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:32:23 04/13/2007 
// Design Name: 
// Module Name:    CPICH_stage 
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

module CPICH(clk, CPICHStart, din_I, din_Q, 
				counter_256, counter_mic, counter_10, counter_15,
				index_group,
				a_square,b_square,out_square,
				we_descramb_a,we_descramb_b,din_descramb_a,din_descramb_b,
				addr_descramb_a,addr_descramb_b,dout_descramb_a,dout_descramb_b,
				we_compare_a,we_compare_b,din_compare_a,din_compare_b,
				addr_compare_a,addr_compare_b,dout_compare_a,dout_compare_b,
				x_temp,y_temp,s_I,s_Q,
				a_IQ,b_IQ,q_IQ,
				a_acc,b_acc,q_acc,a_acc_clear,
				max,index_max,
				state
				);

    input clk;
    input CPICHStart;
    input [17:0] din_I;
    input [17:0] din_Q;
    input [7:0] counter_256;
    input [4:0] counter_mic;
    input [3:0] counter_10;
    input [3:0] counter_15;
	 input [5:0] index_group;
	 input [17:0]	out_square;
	 output [17:0]	a_square;
	 output [17:0]	b_square;
	 
	 
	 output 	we_descramb_a;
	 output 	we_descramb_b;
	 output 	[17:0]	din_descramb_a;
	 output 	[17:0]	din_descramb_b;
    output 	[9:0]	addr_descramb_a;
	 output  [9:0]	addr_descramb_b;
	 output	[17:0]	dout_descramb_a;
	 output	[17:0]	dout_descramb_b;
	 output 	we_compare_a;
	 output 	we_compare_b;
	 output 	[17:0]	din_compare_a;
	 output 	[17:0]	din_compare_b;
    output 	[9:0]	addr_compare_a;
	 output  [9:0]	addr_compare_b;
	 output	[17:0]	dout_compare_a;
	 output	[17:0]	dout_compare_b;
	 output	[17:0]	x_temp;
	 output  [17:0]	y_temp;
	 output	s_I;
	 output 	s_Q;
	 output	[17:0]	a_IQ;
	 output	[17:0]	b_IQ;
	 output	[17:0]	q_IQ;
	 output	[17:0]	a_acc;
	 output 	[17:0]	b_acc;
	 output	[17:0]	q_acc;
	 output	a_acc_clear;
	 output [17:0]	max;
	 output [2:0]	index_max;
	 output	[4:0]	state;

reg [4:0]	state;
reg [4:0]	next_state;

reg [3:0]	nFrame;			//number of frame(38400)

reg [4:0]	counter_mic1;

reg [17:0]	x_temp;
reg [17:0]	y_temp;
wire s_I;
wire s_Q;


wire [9 : 0] addr_descramb_a;
wire [9 : 0] addr_descramb_b;
wire [17 : 0] din_descramb_a;
wire [17 : 0] din_descramb_b;
wire [17 : 0] dout_descramb_a;
wire [17 : 0] dout_descramb_b;
wire we_descramb_a;
wire we_descramb_b;

wire 	we_compare_a;
wire 	we_compare_b;
wire 	[17:0]	din_compare_a;
wire 	[17:0]	din_compare_b;
wire 	[9:0]	addr_compare_a;
wire  [9:0]	addr_compare_b;
wire	[17:0]	dout_compare_a;
wire	[17:0]	dout_compare_b;


wire [17:0]	a_IQ;
wire [17:0]	b_IQ;
wire 			add_IQ;
wire [17:0]	q_IQ;

wire [17:0]	a_acc;
wire [17:0]	b_acc;
wire 			add_acc;
wire [17:0]	q_acc;

reg [17:0]	max;
reg [2:0]	index_max;

wire LoadramOK;
wire DescrambStart;
wire DescrambOK;

reg a_acc_clear;

wire FrameHead;
wire FrameEnd;

parameter 
	Init=				5'b00001,
	Loadram=			5'b00010,
	Wait=				5'b00100,
	Descramb=		5'b01000,

	Compare=			5'b10000;  

assign LoadramOK=(state==Loadram&&counter_mic==15)?1:0;	
assign DescrambStart=(state==Wait&&counter_256==255&&counter_10==9
						&&counter_15==14&&(counter_mic==29||counter_mic==30))?1:0;
assign FrameHead=(counter_256==0&&counter_10==0&&counter_15==0); 
assign FrameEnd=(counter_256==255&&counter_10==9&&counter_15==14);

always @ (posedge clk)
begin
	case(state)
	Descramb:	if((counter_256==0&&counter_mic==1)||(counter_256==1&&counter_mic==1))
						a_acc_clear<=~a_acc_clear;
					else
						a_acc_clear<=a_acc_clear;
	default:		a_acc_clear<=0;
	endcase
end


always @ (posedge clk)
begin
	if(counter_mic==1)
		counter_mic1<=0;
	else
		counter_mic1<=counter_mic1+1;
end

always @ (posedge clk)
begin
	if(CPICHStart)
		nFrame<=0;
	else
		case(state)
		Descramb:	if(counter_256==255&&counter_10==9&&counter_15==14
							&&counter_mic==30)
							nFrame<=nFrame+1;
						else
							nFrame<=nFrame;
		default:	nFrame<=nFrame;
		endcase
end

always @ (posedge clk)
begin
	case(state)
	Descramb:	case(counter_mic)
					1,5,9,13,17,21,25,29:	x_temp<=dout_descramb_a;
					0,4,8,12,16,20,24,28:	
									begin
										x_temp[17]<=(x_temp[7]^x_temp[0]);
										x_temp[16:0]<=(x_temp[17:1]);
									end
					default x_temp<=x_temp;
					endcase
	default:		x_temp<=0;
	endcase
end

always @ (posedge clk)
begin
	case(state)		
	Descramb:	begin
						if(counter_mic==31) 
						begin
							y_temp[17]<=(y_temp[10]^y_temp[7]^y_temp[5]^y_temp[0]);
							y_temp[16:0]<=(y_temp[17:1]);
						end
						else
							if(FrameHead)
								y_temp<=18'b11_1111_1111_1111_1111;
							else
								y_temp<=y_temp;					
					end
	default:		y_temp<=y_temp;
	endcase
end



assign s_I=x_temp[0]^y_temp[0];
assign s_Q=x_temp[15]^x_temp[6]^x_temp[4]^y_temp[5]^y_temp[6]^y_temp[8]^y_temp[9]
				^y_temp[10]^y_temp[11]^y_temp[12]^y_temp[13]^y_temp[14]^y_temp[15];



ram_descramb m_ram_descramb(
	.addra(addr_descramb_a),
	.addrb(addr_descramb_b),
	.clka(clk),
	.clkb(clk),
	.dina(din_descramb_a),
	.dinb(din_descramb_b),
	.douta(dout_descramb_a),
	.doutb(dout_descramb_b),
	.wea(we_descramb_a),
	.web(we_descramb_b));
assign din_descramb_a=(state==Loadram)?dout_descramb_b:x_temp;
assign din_descramb_b=q_acc;
//assign dinb_descramb=(state==Descramb&&counter3[2:0]==0)?x_temp:adder_out;
assign we_descramb_b=(state==Descramb&&FrameHead&&counter_mic[4:1]==0)?0:
						(state==Descramb&&counter_mic[1]==0)?1:0;
assign we_descramb_a=(state==Loadram&&counter_mic[0]==1)?1:
				(state==Descramb&&counter_mic[1:0]==1)?1:
				0;
				
assign addr_descramb_a=
	(state==Loadram)?{{7'b1000_010},counter_mic[3:1]}:
//	(state==Descramb&&counter_mic[1]==1)?{{6'b1000_00},counter_mic[4:2],counter_mic[0]}:
//	(state==Descramb&&FrameHead&&counter_mic[0]==0)?{{7'b1000_010},counter_mic[4:2]}:
	(state==Descramb&&FrameEnd&&counter_mic[4:0]==31)?{10'b1000_0100_00}:
	(state==Descramb&&FrameHead&&(counter_mic[4:0]==0))?{10'b1000_0100_00}:
	(state==Descramb&&FrameHead&&(counter_mic[4:0]==3||counter_mic[4:0]==4))?{10'b1000_0100_01}:
	(state==Descramb&&FrameHead&&(counter_mic[4:0]==7||counter_mic[4:0]==8))?{10'b1000_0100_10}:
	(state==Descramb&&FrameHead&&(counter_mic[4:0]==11||counter_mic[4:0]==12))?{10'b1000_0100_11}:
	(state==Descramb&&FrameHead&&(counter_mic[4:0]==15||counter_mic[4:0]==16))?{10'b1000_0101_00}:
	(state==Descramb&&FrameHead&&(counter_mic[4:0]==19||counter_mic[4:0]==20))?{10'b1000_0101_01}:
	(state==Descramb&&FrameHead&&(counter_mic[4:0]==23||counter_mic[4:0]==24))?{10'b1000_0101_10}:
	(state==Descramb&&FrameHead&&(counter_mic[4:0]==27||counter_mic[4:0]==28))?{10'b1000_0101_11}:
	(state==Descramb&&(counter_mic[4:0]==0||counter_mic[4:0]==31||counter_mic[4:0]==5||counter_mic[4:0]==6))?{10'b1000_0110_00}:
	(state==Descramb&&(counter_mic[4:0]==3||counter_mic[4:0]==4||counter_mic[4:0]==9||counter_mic[4:0]==10))?{10'b1000_0110_01}:
	(state==Descramb&&(counter_mic[4:0]==7||counter_mic[4:0]==8||counter_mic[4:0]==13||counter_mic[4:0]==14))?{10'b1000_0110_10}:
	(state==Descramb&&(counter_mic[4:0]==11||counter_mic[4:0]==12||counter_mic[4:0]==17||counter_mic[4:0]==18))?{10'b1000_0110_11}:
	(state==Descramb&&(counter_mic[4:0]==15||counter_mic[4:0]==16||counter_mic[4:0]==21||counter_mic[4:0]==22))?{10'b1000_0111_00}:
	(state==Descramb&&(counter_mic[4:0]==19||counter_mic[4:0]==20||counter_mic[4:0]==25||counter_mic[4:0]==26))?{10'b1000_0111_01}:
	(state==Descramb&&(counter_mic[4:0]==23||counter_mic[4:0]==24||counter_mic[4:0]==29||counter_mic[4:0]==30))?{10'b1000_0111_10}:
	(state==Descramb&&(counter_mic[4:0]==27||counter_mic[4:0]==28||counter_mic[4:0]==1||counter_mic[4:0]==2))?{10'b1000_0111_11}:
	0; 
					
assign addr_descramb_b=(state==Loadram)?{1'b0,index_group,counter_mic[3:1]}:
					(state==Descramb&&(counter_mic[4:1]==1||counter_mic[4:1]==2))?{{9'b1000_0000_0},counter_mic[0]}:
					(state==Descramb&&(counter_mic[4:1]==3||counter_mic[4:1]==4))?{{9'b1000_0000_1},counter_mic[0]}:
					(state==Descramb&&(counter_mic[4:1]==5||counter_mic[4:1]==6))?{{9'b1000_0001_0},counter_mic[0]}:
					(state==Descramb&&(counter_mic[4:1]==7||counter_mic[4:1]==8))?{{9'b1000_0001_1},counter_mic[0]}:
					(state==Descramb&&(counter_mic[4:1]==9||counter_mic[4:1]==10))?{{9'b1000_0010_0},counter_mic[0]}:
					(state==Descramb&&(counter_mic[4:1]==11||counter_mic[4:1]==12))?{{9'b1000_0010_1},counter_mic[0]}:
					(state==Descramb&&(counter_mic[4:1]==13||counter_mic[4:1]==14))?{{9'b1000_0011_0},counter_mic[0]}:
					(state==Descramb&&(counter_mic[4:1]==15||counter_mic[4:1]==0))?{{9'b1000_0011_1},counter_mic[0]}:				
					0;

ram_1024 m_ram_compare(
	.addra(addr_compare_a),
	.addrb(addr_compare_b),
	.clka(clk),
	.clkb(clk),
	.dina(din_compare_a),
	.dinb(din_compare_b),
	.douta(dout_compare_a),
	.doutb(dout_compare_b),
	.wea(we_compare_a),
	.web(we_compare_b));
	
assign din_compare_a=q_acc;
assign din_compare_b=dout_compare_a+1;
assign we_compare_a=(state==Descramb&&FrameHead&&counter_mic[4:1]==0)?0:
						(state==Descramb&&((counter_256==255&&counter_mic[1]==0)||(counter_256==0&&counter_mic[4:1]==0)))?1:0;
assign we_compare_b=(state==Descramb&&(nFrame!=0||counter_15!=0||counter_10!=0)&&counter_256==16&&counter_mic==13)?1:0;
assign addr_compare_a=
					(state==Descramb&&counter_256==255&&(counter_mic[4:1]==1||counter_mic[4:1]==2))?{{9'b0000_0000_0},counter_mic[0]}:
					(state==Descramb&&counter_256==255&&(counter_mic[4:1]==3||counter_mic[4:1]==4))?{{9'b0000_0000_1},counter_mic[0]}:
					(state==Descramb&&counter_256==255&&(counter_mic[4:1]==5||counter_mic[4:1]==6))?{{9'b0000_0001_0},counter_mic[0]}:
					(state==Descramb&&counter_256==255&&(counter_mic[4:1]==7||counter_mic[4:1]==8))?{{9'b0000_0001_1},counter_mic[0]}:
					(state==Descramb&&counter_256==255&&(counter_mic[4:1]==9||counter_mic[4:1]==10))?{{9'b0000_0010_0},counter_mic[0]}:
					(state==Descramb&&counter_256==255&&(counter_mic[4:1]==11||counter_mic[4:1]==12))?{{9'b0000_0010_1},counter_mic[0]}:
					(state==Descramb&&counter_256==255&&(counter_mic[4:1]==13||counter_mic[4:1]==14))?{{9'b0000_0011_0},counter_mic[0]}:
					(state==Descramb&&((counter_256==255&&counter_mic[4:1]==15)||(counter_256==0&&counter_mic[4:1]==0)))?{{9'b0000_0011_1},counter_mic[0]}:				
					(state==Descramb&&counter_256[7:4]==0)?{6'b000000,counter_256[3:1],1'b0}:
					(state==Descramb&&counter_256==16)?{7'b0000010,index_max}:
					0;
assign addr_compare_b=
					(state==Descramb&&counter_256[7:4]==0)?{6'b000000,counter_256[3:1],1'b1}:
					(state==Descramb&&counter_256==16)?{7'b0000010,index_max}:
					0;

assign a_square=dout_compare_a;
assign b_square=dout_compare_b;

always @ (posedge clk)
begin	
	case(state)
	Descramb:	if(counter_256[7:4]==0&&counter_256[0]==1)
						if(out_square>max)
							max<=out_square;
						else
							max<=max;
					else
						max<=max;
	default:		max<=0;
	endcase
end

always @ (posedge clk)
begin	
	case(state)
	Descramb:	if(counter_256[7:4]==0&&counter_256[0]==1)
						if(out_square>max)
							index_max<=counter_256[3:1];
						else
							index_max<=index_max;
					else
						index_max<=index_max;
	default:		index_max<=0;
	endcase
end

adder_18vs18 adder_IQ(.CLK(clk),.A(a_IQ),.B(b_IQ),.ADD(add_IQ),.Q(q_IQ));
assign a_IQ=(counter_mic[1:0]==2&&s_I==1)?-din_I:
				(counter_mic[1:0]==2&&s_I==0)?din_I:
				(counter_mic[1:0]==3&&s_Q==1)?din_I:
				(counter_mic[1:0]==3&&s_Q==0)?-din_I:0;
assign b_IQ=(counter_mic[1:0]==2&&s_Q==1)?-din_Q:
				(counter_mic[1:0]==2&&s_Q==0)?din_Q:
				(counter_mic[1:0]==3&&s_I==1)?-din_Q:
				(counter_mic[1:0]==3&&s_I==0)?din_Q:0;
assign add_IQ=1;

adder_18vs18 adder_acc(.CLK(clk),.A(a_acc),.B(b_acc),.ADD(add_acc),.Q(q_acc));
assign a_acc=(a_acc_clear==1)?0:dout_descramb_b;
assign b_acc=q_IQ;
assign add_acc=1;

always @ (posedge clk)
if(CPICHStart==0)
	state<=Init;
else
	state<=next_state;


always @ (counter_mic or counter_10 or counter_15 or counter_256)
begin 
	
		case(state)
		Init:			if(counter_mic==30)
							next_state<=Loadram;
						else
							next_state<=Init;
		Loadram:		
						if(LoadramOK)
						
							next_state<=Wait;
						
						else next_state<=Loadram;
		Wait:			if(DescrambStart)
							next_state<=Descramb;
						else
							next_state<=Wait;
		Descramb:	
					begin
						if(DescrambOK)
						begin
							next_state<=Compare;
						end
						else next_state<=Descramb;
					end
		Compare:
					begin
						
						next_state<=Compare;
						
					end
		
    default:next_state<=Init;
    endcase
end

endmodule
