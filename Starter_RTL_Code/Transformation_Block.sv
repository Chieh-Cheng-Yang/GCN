module Transformation_Block #(parameter FEATURE_COLS = 96,
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
)

(
    input clk,
    input reset,
    input start,
    input logic [WEIGHT_WIDTH-1:0] data_in [0:WEIGHT_ROWS-1],
    input [2:0] read_trans_row_1,
    input [2:0] read_trans_row_2,
    output reg enable_read, done_trans,
    output reg [12:0] read_address,
    output logic [DOT_PROD_WIDTH - 1:0] fm_wm_row_out1  [0:WEIGHT_COLS-1],
    output logic [DOT_PROD_WIDTH - 1:0] fm_wm_row_out2  [0:WEIGHT_COLS-1]
);

    wire enable_scratch_pad_weight_w, enable_scratch_pad_feature_w;
    wire [15:0] accumulated_sum_w;
    wire enable_weight_counter_w, enable_feature_counter_w;
    wire [1:0] weight_count_w;
    wire [2:0] feature_count_w;
    wire enabe_write_FM_WM_Prod_w, enable_accumulator_w;
    wire [4:0] feature_col_w [0:7];
    wire [4:0] weight_row_w [0:7];
    wire read_feature_or_weight_w;
    wire [12:0] partial_sum_w;









Transformation_FSM Transformation_FSM_inst(
    .clk(clk),
    .reset(reset),
    .weight_count(weight_count_w),
    .feature_count(feature_count_w),
    .start(start),
    .enable_accumulator(enable_accumulator_w),
    .enable_write_fm_wm_prod(enabe_write_FM_WM_Prod_w),
    .enable_read(enable_read),
    // .enable_write(),
    .enable_scratch_pad_feature(enable_scratch_pad_feature_w),
    .enable_scratch_pad_weight(enable_scratch_pad_weight_w),
    .enable_weight_counter(enable_weight_counter_w),
    .enable_feature_counter(enable_feature_counter_w),
    .read_feature_or_weight(read_feature_or_weight_w), 
    .read_address(read_address),
    .done(done_trans)
);

Matrix_FM_WM_Memory Matrix_FM_WM_Memory_inst(
    .clk(clk),
    .rst(reset),
    .write_row(feature_count_w),
    .write_col(weight_count_w),
    .read_row1(read_trans_row_1),
    .read_row2(read_trans_row_2),
    .wr_en(enabe_write_FM_WM_Prod_w),
    .fm_wm_in(accumulated_sum_w),
    .fm_wm_row_out1(fm_wm_row_out1),
    .fm_wm_row_out2(fm_wm_row_out2)
);


Weight_Counter Weight_Counter_inst(
    .clk(clk),
    .reset(reset),
    .enable_weight_counter(enable_weight_counter_w),
    .weight_count(weight_count_w)
);

Feature_Counter Feature_Counter_inst(
    .clk(clk),
    .reset(reset),
    .enable_feature_counter(enable_feature_counter_w),
    .feature_count(feature_count_w)
);

Scratch_Pad_Feature Scratch_Pad_Feature_inst(
  .clk(clk),
  .reset(reset),
  .write_enable(enable_scratch_pad_feature_w),
  .feature_col_in(data_in),
  .enable_accumulator(enable_accumulator_w),
  .feature_col_out(feature_col_w)
);


Scratch_Pad_Weight Scratch_Pad_Weight_inst(
  .clk(clk),
  .reset(reset),
  .write_enable(enable_scratch_pad_weight_w),
  .enable_accumulator(enable_accumulator_w),
  .weight_row_in(data_in),
  .weight_row_out(weight_row_w)
);

Accumulator Accumulator_inst(
    .clk(clk),
    .reset(reset),
    .partial_sum(partial_sum_w),
    .enable_accumulator(enable_accumulator_w),
    .accumulated_sum(accumulated_sum_w)
);

Vector_Multiplier Vector_Multiplier_inst(
    .feature(feature_col_w),
    .weight(weight_row_w),
    .partial_sum(partial_sum_w)
);



endmodule