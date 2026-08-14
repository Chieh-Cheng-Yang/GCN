
module Scratch_Pad_Feature
  #(parameter feature_COLUMNS = 96,
    parameter feature_WIDTH = 5
)

(
  input logic clk,
  input logic reset,
  input logic write_enable,
  input wire [feature_WIDTH-1:0] feature_col_in [0:feature_COLUMNS-1],
  input wire enable_accumulator,
  output logic [feature_WIDTH-1:0] feature_col_out [0:7]
//   output logic [feature_WIDTH-1:0] feature_col_out [0:feature_COLUMNS-1]
);

reg [4:0] cnt;

 logic [feature_WIDTH-1:0] memory [0:feature_COLUMNS-1];

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin 
       for (int i = 0; i < feature_COLUMNS; i = i + 1) begin
          memory[i] <= '0;
       end
       cnt <= 1'b0;
    end
    else if (write_enable) begin
        memory <= feature_col_in;
        cnt <= 1'b0;
    end
    else if (enable_accumulator) begin
        cnt <= cnt + 1'b1;
    end else begin
        cnt <= 0;
    end
  end

//   assign feature_col_out = memory[cnt*8:cnt*8 + 7];
    always_comb begin
        for (int i = 0; i < 8; i = i + 1) begin
            feature_col_out[i] = memory[cnt*8 + i];
        end
    end

endmodule