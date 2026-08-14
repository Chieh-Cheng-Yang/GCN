module Argmax #(parameter FEATURE_COLS = 96,
    parameter WEIGHT_ROWS = 96,
    parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter FEATURE_WIDTH = 5,
    parameter WEIGHT_WIDTH = 5,
    parameter DOT_PROD_WIDTH = 16,
    parameter ADDRESS_WIDTH = 13,
    parameter COUNTER_WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter COUNTER_FEATURE_WIDTH = $clog2(FEATURE_ROWS),
    parameter MAX_ADDRESS_WIDTH = 2,
    parameter NUM_OF_NODES = 6,			 
    parameter COO_NUM_OF_COLS = 6,			
    parameter COO_NUM_OF_ROWS = 2,			
    parameter COO_BW = $clog2(COO_NUM_OF_COLS)	
)(
    input wire clk,
    input wire reset,
    input wire done_comb,
    input wire [DOT_PROD_WIDTH-1:0] ADJ_FM_WM_Row_data [0:WEIGHT_COLS-1],
    output wire [COO_BW-1:0] read_row,
    output logic done,
    output logic [1:0] max_addi_ans [0:5]
);

reg [2:0] count;
assign read_row = count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        done <= 1'b0;
        count <= 3'd0;
    end else if (done_comb && !done) begin
        if (ADJ_FM_WM_Row_data[0] > ADJ_FM_WM_Row_data[1] && ADJ_FM_WM_Row_data[0] > ADJ_FM_WM_Row_data[2]) begin
            max_addi_ans[count] <= 2'd0;
        end else if (ADJ_FM_WM_Row_data[1] > ADJ_FM_WM_Row_data[2] && ADJ_FM_WM_Row_data[1] > ADJ_FM_WM_Row_data[0]) begin
            max_addi_ans[count] <= 2'd1;
        end else begin
            max_addi_ans[count] <= 2'd2;
        end
        count <= count + 1;
        if (count == 3'd5) begin
            done <= 1'b1;
        end
    end
end
endmodule