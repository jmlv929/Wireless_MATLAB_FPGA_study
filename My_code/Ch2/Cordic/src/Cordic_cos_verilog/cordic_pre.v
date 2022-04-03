module cordic_pre(     //decide phase which quadrant
    clk,
    aresetn,
    phase,             // phase (-pi,pi)

    quadrant_flag,
    phase_pre
);
// input and output signals

input clk;
input aresetn;
input signed [21:0] phase;
output reg[1:0] quadrant_flag; 
output reg signed [21:0] phase_pre;

// parameters

parameter quadrant_first = 2'b00,
quadrant_second = 2'b01,
quadrant_third = 2'b11,
quadrant_fourth = 2'b10;

parameter angle_90 = 22'sd90_0000,  //90 deg
angle_0 = 22'sd0,
angle_n_90 = -22'sd90_0000,   // -90 deg
angle_180 = 22'sd180_0000;

// inter signals

always@(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        phase_pre <= 0;
        quadrant_flag <= quadrant_first;
    end
    else begin
        if(phase>=0 && phase<=angle_90)begin
            phase_pre <= phase;
            quadrant_flag <= quadrant_first;
        end
        else if(phase>angle_90) begin
            phase_pre <= phase - angle_180;
            quadrant_flag <= quadrant_second;
        end
        else if(phase<0 && phase>=angle_n_90) begin
            phase_pre <= phase;
            quadrant_flag <= quadrant_fourth;
        end
        else if(phase<angle_n_90) begin
            phase_pre <= phase + angle_180;
            quadrant_flag <= quadrant_third;
        end
    end
end

endmodule