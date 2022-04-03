module cordic_quad_post(
    input clk,
    input aresetn,

    input [1:0] quadrant,
    input signed [23:0] cos_pre,
    input signed [23:0] sin_pre,
    output reg signed[23:0] cos,
    output reg signed[23:0] sin
);
// parameters
parameter x_init = 10_0000;

always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        cos <= 0;
        sin <= 0;
    end
    else begin
        case(quadrant)
            2'b00:begin  // first quad
                cos <= cos_pre;
                sin <= sin_pre;
            end
            2'b01:begin  // second quad
                cos <= -cos_pre;
                sin <= -sin_pre;
            end
            2'b10:begin  // fourth quad
                cos <= cos_pre;
                sin <= sin_pre;
            end
            2'b11:begin  // third quad
                cos <= -cos_pre;
                sin <= -sin_pre;
            end
            default:begin  //  unknown
                cos <= cos_pre;
                sin <= sin_pre;
            end
        endcase
    end
end

endmodule