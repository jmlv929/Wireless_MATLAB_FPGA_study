module divider(
    input clk,
    input signed[7:0] a,
    input signed[7:0] b,
    output reg signed[7:0] q
);

always@(posedge clk) begin
    q <= a / b;
end

endmodule