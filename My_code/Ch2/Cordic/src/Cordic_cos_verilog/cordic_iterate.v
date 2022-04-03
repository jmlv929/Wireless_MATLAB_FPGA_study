module cordic_iterate (  // 14级旋转
    clk,
    aresetn,

    phase_pre,   //经放大了10000倍
    quadrant_flag,

    cos_pre,
    sin_pre,
    quadrant
);
// ports
input clk;
input aresetn;
input signed[21:0] phase_pre;
input [1:0] quadrant_flag;

output [1:0] quadrant;
output wire signed [23:0] cos_pre;
output wire signed [23:0] sin_pre;
//parameters
parameter x_init = 10_0000,  // 不能太小 取值为1_0000 最后得到的数除以这个数就是最终的值
y_init = 0;

parameter a1 = 45_0000, //放大10000倍 旋转角度
a2 = 26_5651,
a3 = 14_0362,
a4 = 7_1250,
a5 = 3_5763,
a6 = 1_7899,
a7 = 8952,
a8 = 4476,
a9 = 2238,
a10 = 1119,
a11 = 560,
a12 = 280,
a13 = 140,
a14 = 70;


parameter k14 = 16468;  //需要 *模校正因子0.6072529365170104
//等价于除以 1.6468  等价于 *10000 /16468

// 内部信号
reg signed [23:0] X [14:0];
reg signed [23:0] Y [14:0];
reg [1:0] Quad[14:0];  //象限 没有符号
reg signed [21:0] Theta [14:0];


//内部处理

always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        X[0] <= 0;
        Y[0] <= 0;
        Theta[0] <= 0;
    end
    else begin
        X[0] <= x_init;
        Y[0] <= y_init;
        Theta[0] <= phase_pre;
    end
end

//第1次旋转
always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        X[1] <= 0;
        Y[1] <= 0;
        Theta[1] <= 0;
    end
    else if(Theta[0]>=0) begin
        X[1] <= X[0] - Y[0];
        Y[1] <= Y[0] + X[0];
        Theta[1] <= Theta[0] - a1;
    end
    else if(Theta[0]<0) begin
        X[1] <= X[0] + Y[0];
        Y[1] <= Y[0] - X[0];
        Theta[1] <= Theta[0] + a1;
    end
end

//第2次旋转
always@(posedge clk or negedge aresetn) begin   //二元 + 优先级高于移位
    if(!aresetn) begin
        X[2] <= 0;
        Y[2] <= 0;
        Theta[2] <= 0;
    end
    else if(Theta[1]>=0) begin
        X[2] <= X[1] - (Y[1]>>>1);  //算数右移 *0.5
        Y[2] <= Y[1] + (X[1]>>>1);  //移位加括号
        Theta[2] <= Theta[1] - a2;
    end
    else if(Theta[1]<0) begin
        X[2] <= X[1] + (Y[1]>>>1);
        Y[2] <= Y[1] - (X[1]>>>1);
        Theta[2] <= Theta[1] + a2;
    end
end

//第3次旋转
always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        X[3] <= 0;
        Y[3] <= 0;
        Theta[3] <= 0;
    end
    else if(Theta[2]>=0) begin
        X[3] <= X[2] - (Y[2]>>>2);
        Y[3] <= Y[2] + (X[2]>>>2);
        Theta[3] <= Theta[2] - a3;
    end
    else if(Theta[2]<0) begin
        X[3] <= X[2] + (Y[2]>>>2);
        Y[3] <= Y[2] - (X[2]>>>2);
        Theta[3] <= Theta[2] + a3;
    end
end

//第4次旋转
always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        X[4] <= 0;
        Y[4] <= 0;
        Theta[4] <= 0;
    end
    else if(Theta[3]>=0) begin
        X[4] <= X[3] - (Y[3]>>>3);
        Y[4] <= Y[3] + (X[3]>>>3);
        Theta[4] <= Theta[3] - a4;
    end
    else if(Theta[3]<0) begin
        X[4] <= X[3] + (Y[3]>>>3);
        Y[4] <= Y[3] - (X[3]>>>3);
        Theta[4] <= Theta[3] + a4;
    end
end
//第5次旋转
always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        X[5] <= 0;
        Y[5] <= 0;
        Theta[5] <= 0;
    end
    else if(Theta[4]>=0) begin
        X[5] <= X[4] - (Y[4]>>>4);
        Y[5] <= Y[4] + (X[4]>>>4);
        Theta[5] <= Theta[4] - a5;
    end
    else if(Theta[4]<0) begin
        X[5] <= X[4] + (Y[4]>>>4);
        Y[5] <= Y[4] - (X[4]>>>4);
        Theta[5] <= Theta[4] + a5;
    end
end
//第6次旋转
always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        X[6] <= 0;
        Y[6] <= 0;
        Theta[6] <= 0;
    end
    else if(Theta[5]>=0) begin
        X[6] <= X[5] - (Y[5]>>>5);
        Y[6] <= Y[5] + (X[5]>>>5);
        Theta[6] <= Theta[5] - a6;
    end
    else if(Theta[5]<0) begin
        X[6] <= X[5] + (Y[5]>>>5);
        Y[6] <= Y[5] - (X[5]>>>5);
        Theta[6] <= Theta[5] + a6;
    end
end
//第7次旋转
always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        X[7] <= 0;
        Y[7] <= 0;
        Theta[7] <= 0;
    end
    else if(Theta[6]>=0) begin
        X[7] <= X[6] - (Y[6]>>>6);
        Y[7] <= Y[6] + (X[6]>>>6);
        Theta[7] <= Theta[6] - a7;
    end
    else if(Theta[6]<0) begin
        X[7] <= X[6] + (Y[6]>>>6);
        Y[7] <= Y[6] - (X[6]>>>6);
        Theta[7] <= Theta[6] + a7;
    end
end
//第8次旋转
always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        X[8] <= 0;
        Y[8] <= 0;
        Theta[8] <= 0;
    end
    else if(Theta[7]>=0) begin
        X[8] <= X[7] - (Y[7]>>>7);
        Y[8] <= Y[7] + (X[7]>>>7);
        Theta[8] <= Theta[7] - a8;
    end
    else if(Theta[7]<0) begin
        X[8] <= X[7] + (Y[7]>>>7);
        Y[8] <= Y[7] - (X[7]>>>7);
        Theta[8] <= Theta[7] + a8;
    end
end
//第9次旋转
always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        X[9] <= 0;
        Y[9] <= 0;
        Theta[9] <= 0;
    end
    else if(Theta[8]>=0) begin
        X[9] <= X[8] - (Y[8]>>>8);
        Y[9] <= Y[8] + (X[8]>>>8);
        Theta[9] <= Theta[8] - a9;
    end
    else if(Theta[8]<0) begin
        X[9] <= X[8] + (Y[8]>>>8);
        Y[9] <= Y[8] - (X[8]>>>8);
        Theta[9] <= Theta[8] + a9;
    end
end
//第10次旋转
always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        X[10] <= 0;
        Y[10] <= 0;
        Theta[10] <= 0;
    end
    else if(Theta[9]>=0) begin
        X[10] <= X[9] - (Y[9]>>>9);
        Y[10] <= Y[9] + (X[9]>>>9);
        Theta[10] <= Theta[9] - a10;
    end
    else if(Theta[9]<0) begin
        X[10] <= X[9] + (Y[9]>>>9);
        Y[10] <= Y[9] - (X[9]>>>9);
        Theta[10] <= Theta[9] + a10;
    end
end
//第11次旋转
always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        X[11] <= 0;
        Y[11] <= 0;
        Theta[11] <= 0;
    end
    else if(Theta[10]>=0) begin
        X[11] <= X[10] - (Y[10]>>>10);
        Y[11] <= Y[10] + (X[10]>>>10);
        Theta[11] <= Theta[10] - a11;
    end
    else if(Theta[10]<0) begin
        X[11] <= X[10] + (Y[10]>>>10);
        Y[11] <= Y[10] - (X[10]>>>10);
        Theta[11] <= Theta[10] + a11;
    end
end
//第12次旋转
always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        X[12] <= 0;
        Y[12] <= 0;
        Theta[12] <= 0;
    end
    else if(Theta[11]>=0) begin
        X[12] <= X[11] - (Y[11]>>>11);
        Y[12] <= Y[11] + (X[11]>>>11);
        Theta[12] <= Theta[11] - a12;
    end
    else if(Theta[11]<0) begin
        X[12] <= X[11] + (Y[11]>>>11);
        Y[12] <= Y[11] - (X[11]>>>11);
        Theta[12] <= Theta[11] + a12;
    end
end
//第13次旋转
always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        X[13] <= 0;
        Y[13] <= 0;
        Theta[13] <= 0;
    end
    else if(Theta[12]>=0) begin
        X[13] <= X[12] - (Y[12]>>>12);
        Y[13] <= Y[12] + (X[12]>>>12);
        Theta[13] <= Theta[12] - a13;
    end
    else if(Theta[12]<0) begin
        X[13] <= X[12] + (Y[12]>>>12);
        Y[13] <= Y[12] - (X[12]>>>12);
        Theta[13] <= Theta[12] + a13;
    end
end
//第14次旋转
always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        X[14] <= 0;
        Y[14] <= 0;
        Theta[14] <= 0;
    end
    else if(Theta[13]>=0) begin
        X[14] <= X[13] - (Y[13]>>>13);
        Y[14] <= Y[13] + (X[13]>>>13);
        Theta[14] <= Theta[13] - a14;
    end
    else if(Theta[13]<0) begin
        X[14] <= X[13] + (Y[13]>>>13);
        Y[14] <= Y[13] - (X[13]>>>13);
        Theta[14] <= Theta[13] + a14;
    end
end

//输出逻辑

assign cos_pre = X[14]*10000/k14;  //乘以模校正因子 这里采用先乘再除的方式  要保证X[14]足够位数
assign sin_pre = Y[14]*10000/k14;
assign quadrant = Quad[14];

always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        Quad[0] <= 0;
        Quad[1] <= 0;
        Quad[2] <= 0;
        Quad[3] <= 0;
        Quad[4] <= 0;
        Quad[5] <= 0;
        Quad[6] <= 0;
        Quad[7] <= 0;
        Quad[8] <= 0;
        Quad[9] <= 0;
        Quad[10] <= 0;
        Quad[11] <= 0;
        Quad[12] <= 0;
        Quad[13] <= 0;
        Quad[14] <= 0;
    end
    else begin
       Quad[0] <= quadrant_flag;
       Quad[1] <= Quad[0];
       Quad[2] <= Quad[1];
       Quad[3] <= Quad[2];
       Quad[4] <= Quad[3];
       Quad[5] <= Quad[4];
       Quad[6] <= Quad[5];
       Quad[7] <= Quad[6];
       Quad[8] <= Quad[7];
       Quad[9] <= Quad[8];
       Quad[10] <= Quad[9];
       Quad[11] <= Quad[10];
       Quad[12] <= Quad[11];
       Quad[13] <= Quad[12];
       Quad[14] <= Quad[13];
    end
end

endmodule