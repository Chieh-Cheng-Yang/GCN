module GCN
  #(parameter FEATURE_COLS = 96,
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
  input logic clk,	// Clock
  input logic reset,	// Reset 
  input logic start,
  input logic [WEIGHT_WIDTH-1:0] data_in [0:WEIGHT_ROWS-1], //FM and WM Data
  input logic [COO_BW - 1:0] coo_in [0:1], //row 0 and row 1 of the COO Stream

  output logic [COO_BW - 1:0] coo_address, // The column of the COO Matrix 
  output logic [ADDRESS_WIDTH-1:0] read_address, // The Address to read the FM and WM Data
  output logic enable_read, // Enabling the Read of the FM and WM Data
  output logic done, // Done signal indicating that all the calculations have been completed
  output logic [MAX_ADDRESS_WIDTH - 1:0] max_addi_answer [0:FEATURE_ROWS - 1] // The answer to the argmax and matrix multiplication 
); 


wire [DOT_PROD_WIDTH-1:0] ADJ_FM_WM_Row_data_w [0:WEIGHT_COLS-1];
wire done_trans_w;
wire [DOT_PROD_WIDTH-1:0] FM_WM_row_data [0:WEIGHT_COLS-1];
wire [2:0] read_trans_row;
wire [DOT_PROD_WIDTH-1:0] fm_wm_row_out1_w [0:WEIGHT_COLS-1];
wire [DOT_PROD_WIDTH-1:0] fm_wm_row_out2_w [0:WEIGHT_COLS-1];
wire [2:0] read_trans_row_1, read_trans_row_2;
wire done_comb_w;
wire [2:0] read_row_w;

Transformation_Block Transformation_Block_inst(
    .clk(clk),
    .reset(reset),
    .start(start),
    .data_in(data_in),
    .read_trans_row_1(read_trans_row_1),
    .read_trans_row_2(read_trans_row_2),

    .enable_read(enable_read), 
    .done_trans(done_trans_w),
    .read_address(read_address),
    .fm_wm_row_out1(fm_wm_row_out1_w),
    .fm_wm_row_out2(fm_wm_row_out2_w)
);

Combination_Block Combination_Block_inst(
    .clk(clk),
    .reset(reset),
    .start(start),
    .coo_in(coo_in),
    .done_trans(done_trans_w),
    .FM_WM_row_data1(fm_wm_row_out1_w),
    .FM_WM_row_data2(fm_wm_row_out2_w),
    .read_ADJ_row(read_row_w),
    .coo_address(coo_address),
    .done_comb(done_comb_w),
    .ADJ_FM_WM_Row_data(ADJ_FM_WM_Row_data_w),
    .read_trans_row_1(read_trans_row_1),
    .read_trans_row_2(read_trans_row_2)
);
    
Argmax Argmax_inst(
    .clk(clk),
    .reset(reset),
    .done_comb(done_comb_w),
    .ADJ_FM_WM_Row_data(ADJ_FM_WM_Row_data_w),
    .read_row(read_row_w),
    .done(done),
    .max_addi_ans(max_addi_answer)
);

endmodule
