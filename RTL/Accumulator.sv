module Accumulator(
    input clk,
    input reset,
    input [12:0] partial_sum,
    input enable_accumulator,
    output reg [15:0] accumulated_sum
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            accumulated_sum <= 16'd0;
        end else if (enable_accumulator) begin
            accumulated_sum <= accumulated_sum + partial_sum;
        end else accumulated_sum <= 0;
    end

endmodule