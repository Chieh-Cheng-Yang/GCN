module Weight_Counter(
    input clk,
    input reset,
    input enable_weight_counter,
    output reg [1:0] weight_count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            weight_count <= 2'd0;
        end else if (enable_weight_counter) begin
            weight_count <= (weight_count == 2'd2) ? 2'd0 : weight_count + 2'd1;
        end
    end

endmodule