module Mult_ADJ #(parameter FEATURE_COLS = 96,
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
    input logic [DOT_PROD_WIDTH-1:0] fm_wm_row_in1 [0:2],
    input logic [DOT_PROD_WIDTH-1:0] fm_wm_row_in2 [0:2],
    input logic [DOT_PROD_WIDTH-1:0] ADJ_fm_wm_row_in1 [0:2],
    input logic [DOT_PROD_WIDTH-1:0] ADJ_fm_wm_row_in2 [0:2],
    output logic [DOT_PROD_WIDTH-1:0] mult_result1 [0:2],
    output logic [DOT_PROD_WIDTH-1:0] mult_result2 [0:2]
);

    assign mult_result1[0] = fm_wm_row_in1[0] + ADJ_fm_wm_row_in1[0];
    assign mult_result1[1] = fm_wm_row_in1[1] + ADJ_fm_wm_row_in1[1];
    assign mult_result1[2] = fm_wm_row_in1[2] + ADJ_fm_wm_row_in1[2];

    assign mult_result2[0] = fm_wm_row_in2[0] + ADJ_fm_wm_row_in2[0];
    assign mult_result2[1] = fm_wm_row_in2[1] + ADJ_fm_wm_row_in2[1];
    assign mult_result2[2] = fm_wm_row_in2[2] + ADJ_fm_wm_row_in2[2];

endmodule