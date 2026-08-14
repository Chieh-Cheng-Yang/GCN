module Vector_Multiplier(
    input [4:0] feature [7:0],
    input [4:0] weight [7:0],
    output reg [12:0] partial_sum
);

    reg [9:0] product_temp [7:0];

    always @(*) begin
        for (int i = 0; i < 8; i = i + 1) begin
            product_temp[i] = feature[i] * weight[i];
        end
        partial_sum = product_temp[0] + product_temp[1] + product_temp[2] + product_temp[3] +
                      product_temp[4] + product_temp[5] + product_temp[6] + product_temp[7];
    end




endmodule