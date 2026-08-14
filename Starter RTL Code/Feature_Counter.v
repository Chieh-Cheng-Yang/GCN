module Feature_Counter(
    input clk,
    input reset,
    input enable_feature_counter,
    output reg [2:0] feature_count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            feature_count <= 3'd0;
        end else if (enable_feature_counter) begin
            feature_count <= (feature_count == 3'd5) ? 3'd0 : feature_count + 1;
        end
    end


endmodule