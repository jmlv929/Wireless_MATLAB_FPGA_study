module top_module(
    input clk,
    input aresetn,

    input signed [21:0]phase,  // phase (-180，180)  角度制 将输出扩大10000倍 比如输入 求45deg phase = 45_0000
    output signed[23:0] cos,
    output signed[23:0] sin
);                                        // 1(pre) + 15(iterate) + 1(post) 级延迟
// parameters
parameter x_init = 10_0000;    //最后的得到的 cos 以及 sin signed decimal 除以 x_init就是 实际浮点值


wire[1:0] quadrant_flag;
wire signed [21:0] phase_pre;
wire [1:0] quadrant;
wire signed [23:0] cos_pre;
wire signed [23:0] sin_pre;


cordic_pre cordic_pre_0(     //decide phase which quadrant
    .clk(clk),
    .aresetn(aresetn),
    .phase(phase),             // phase (-pi,pi)

    .quadrant_flag(quadrant_flag),
    .phase_pre(phase_pre)
);

cordic_iterate #(
    .x_init(x_init)
) cordic_iterate_0(  // 14级旋转
    .clk(clk),
    .aresetn(aresetn),

    .phase_pre(phase_pre),   //经放大了10000倍
    .quadrant_flag(quadrant_flag),

    .cos_pre(cos_pre),
    .sin_pre(sin_pre),
    .quadrant(quadrant)
);

cordic_quad_post cordic_quad_post_0(
    .clk(clk),
    .aresetn(aresetn),

    .quadrant(quadrant),
    .cos_pre(cos_pre),
    .sin_pre(sin_pre),

    .cos(cos),
    .sin(sin)
);

endmodule