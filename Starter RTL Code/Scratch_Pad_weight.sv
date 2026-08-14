
module Scratch_Pad_Weight 
  #(parameter WEIGHT_ROWS = 96,
    parameter WEIGHT_WIDTH = 5
)

(
  input logic clk,
  input logic reset,
  input logic write_enable,
  input wire [WEIGHT_WIDTH-1:0] weight_row_in [0:WEIGHT_ROWS-1],
  input wire enable_accumulator,
  output logic [WEIGHT_WIDTH-1:0] weight_row_out [0:7]
);

    reg [4:0] cnt;
    logic [WEIGHT_WIDTH-1:0] memory [0:WEIGHT_ROWS-1];

  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin 
        for (int i = 0; i < WEIGHT_ROWS; i = i + 1) begin
            memory[i] <= '0;
        end
        cnt <= 1'b0;
    end
    else if (write_enable) begin
        memory <= weight_row_in;
        cnt <= 1'b0;
    end else if (enable_accumulator) begin
        cnt <= cnt + 1'b1;
    end else begin
        cnt <= 0;
    end
  end

//   assign weight_row_out = memory[cnt*8:cnt*8 + 7];
  always_comb begin
        for (int i = 0; i < 8; i = i + 1) begin
            weight_row_out[i] = memory[cnt*8 + i];
        end
    end

endmodule