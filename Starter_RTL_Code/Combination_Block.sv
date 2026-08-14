module Combination_Block#(parameter FEATURE_COLS = 96,
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
) (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [2:0] coo_in [0:COO_NUM_OF_ROWS-1],
    input wire done_trans,
    input wire [DOT_PROD_WIDTH-1:0] FM_WM_row_data1 [0:WEIGHT_COLS-1],
    input wire [DOT_PROD_WIDTH-1:0] FM_WM_row_data2 [0:WEIGHT_COLS-1],
    input wire [2:0] read_ADJ_row,
    output logic [COO_BW-1:0] coo_address,
    output logic done_comb,
    output logic [DOT_PROD_WIDTH-1:0] ADJ_FM_WM_Row_data [0:WEIGHT_COLS-1],
    output logic [2:0] read_trans_row_1,
    output logic [2:0] read_trans_row_2
);

    wire [DOT_PROD_WIDTH-1:0] adj_fm_wm_out_w [0:WEIGHT_COLS-1];
    wire [DOT_PROD_WIDTH-1:0] fm_wm_adj_out_mult1_w [0:WEIGHT_COLS-1];
    wire [DOT_PROD_WIDTH-1:0] fm_wm_adj_out_mult2_w [0:WEIGHT_COLS-1];
    wire [2:0] write_row, row_count_w;
    wire [DOT_PROD_WIDTH-1:0] mult_result1_w [0:WEIGHT_COLS-1];
    wire [DOT_PROD_WIDTH-1:0] mult_result2_w [0:WEIGHT_COLS-1];

    reg en_mem;
    
    assign read_trans_row_1 = coo_in[1] - 1;
    assign read_trans_row_2 = coo_in[0] - 1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done_comb <= 1'b0;
            en_mem <= 1'b0;
        end else if (coo_address == 3'd5) begin
            done_comb <= 1'b1;
            en_mem <= 1'b0;
        end else if (done_trans) begin
            en_mem <= 1'b1;
        end 
    end

Mult_ADJ Mult_ADJ_inst(
    .fm_wm_row_in1(FM_WM_row_data1),
    .fm_wm_row_in2(FM_WM_row_data2),
    .ADJ_fm_wm_row_in1(fm_wm_adj_out_mult1_w),
    .ADJ_fm_wm_row_in2(fm_wm_adj_out_mult2_w),
    .mult_result1(mult_result1_w),
    .mult_result2(mult_result2_w)
);

Matrix_FM_WM_ADJ_Memory Matrix_FM_WM_ADJ_Memory_inst
(
    .clk(clk),
    .rst(reset),
    .write_row1(coo_in[0]),
    .write_row2(coo_in[1]),
    .read_row(read_ADJ_row),  //不是trans的  是argmax要讀的
    // .wr_en(en_mem),
    .wr_en(done_trans && !done_comb),
    .fm_wm_adj_row_in1(mult_result1_w),
    .fm_wm_adj_row_in2(mult_result2_w),
    .fm_wm_adj_out_mult1(fm_wm_adj_out_mult1_w), 
    .fm_wm_adj_out_mult2(fm_wm_adj_out_mult2_w),
    .fm_wm_adj_out(ADJ_FM_WM_Row_data) //接給Argmax的
);

FM_WM_ROW_Counter FM_WM_ROW_Counter_inst(
    .clk(clk),
    .reset(reset),
    .done_trans(done_trans),
    .coo_address(coo_address)
);

    
endmodule