
module Transformation_FSM 
  #(parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter COUNTER_WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter COUNTER_FEATURE_WIDTH = $clog2(FEATURE_ROWS))
(
  input logic clk,
  input logic reset,
  input logic [COUNTER_WEIGHT_WIDTH-1:0] weight_count,
  input logic [COUNTER_FEATURE_WIDTH-1:0] feature_count,
  input logic start,


  output logic enable_write_fm_wm_prod,
  output logic enable_read,
//   output logic enable_write,
  output logic enable_scratch_pad_weight,
  output logic enable_scratch_pad_feature,
  output logic enable_weight_counter,
  output logic enable_feature_counter,
  output logic read_feature_or_weight, 
  output logic enable_accumulator,
  output logic done,
  output logic [12:0] read_address
);

  typedef enum logic [3:0] {
	START,
    	READ_WEIGHT_DATA,
    	INCREMENT_WEIGHT_COUNTER,
	READ_FEATURE_DATA,
	INCREMENT_FEATURE_COUNTER,
	DONE,
    VECTOR_MULTIPLY
  } state_t;

  state_t current_state, next_state;
    reg [3:0] multiply_counter;
  always_ff @(posedge clk or posedge reset)
    if (reset) begin
        current_state <= START;
        multiply_counter <= 4'b0000;
    end else begin 
        current_state <= next_state;

        if (current_state == VECTOR_MULTIPLY) begin
            if (multiply_counter == 4'd11)
                multiply_counter <= 4'd0;
            else
                multiply_counter <= multiply_counter + 1'b1;
        end
        else begin
            multiply_counter <= 4'd0;
        end
    end
      

  always_comb begin
    case (current_state)

      START: begin
		enable_write_fm_wm_prod = 1'b0;
        	enable_read = 1'b0;
		// enable_write = 1'b0;
		enable_scratch_pad_weight = 1'b0;
        enable_scratch_pad_feature = 1'b0;
		enable_weight_counter = 1'b0;
		enable_feature_counter = 1'b0;
		read_feature_or_weight = 1'b0; 
        enable_accumulator = 1'b0;
		done = 1'b0;

		if (start) begin
			next_state = READ_WEIGHT_DATA;
		end 
		else begin 
			next_state = START;
		end 
        	
      end

      READ_WEIGHT_DATA: begin
		enable_write_fm_wm_prod = 1'b0;
		enable_read = 1'b1;
		// enable_write = 1'b0;
		enable_scratch_pad_weight = 1'b1;
        enable_scratch_pad_feature = 1'b0;
		enable_weight_counter = 1'b0;
		enable_feature_counter = 1'b0;
		read_feature_or_weight=  1'b0; 
        enable_accumulator = 1'b0;
		done = 1'b0;
        read_address = weight_count;

		next_state = READ_FEATURE_DATA;
      end

      INCREMENT_WEIGHT_COUNTER: begin
		enable_write_fm_wm_prod = 1'b0;
        	enable_read = 1'b0;
		// enable_write = 1'b0;
		enable_scratch_pad_weight = 1'b0;
        enable_scratch_pad_feature = 1'b0;
		enable_weight_counter = 1'b1;
		enable_feature_counter = 1'b0;
		read_feature_or_weight=  1'b0; 
        enable_accumulator = 1'b0;
		done = 1'b0;

        	next_state = READ_WEIGHT_DATA;
      end

      READ_FEATURE_DATA: begin
		enable_write_fm_wm_prod = 1'b0;
        enable_read = 1'b1;
		// enable_write = 1'b0;
		enable_scratch_pad_weight = 1'b0;
        enable_scratch_pad_feature = 1'b1;
		enable_weight_counter = 1'b0;
		enable_feature_counter = 1'b0;
		read_feature_or_weight = 1'b1; 
        enable_accumulator = 1'b0;
        read_address = feature_count + 10'b10_0000_0000;
		done = 1'b0;

        	next_state = VECTOR_MULTIPLY;
      end

      VECTOR_MULTIPLY: begin
        enable_write_fm_wm_prod = 1'b0;
        enable_read = 1'b0;
        // enable_write = 1'b0;
        enable_scratch_pad_weight = 1'b0;
        enable_scratch_pad_feature = 1'b0;
        enable_weight_counter = 1'b0;
        enable_feature_counter = 1'b0;
        read_feature_or_weight = 1'b0; 
        enable_accumulator = 1'b1;
        done = 1'b0;

        next_state = (multiply_counter == 4'd11) ? INCREMENT_FEATURE_COUNTER : VECTOR_MULTIPLY;
      end

      INCREMENT_FEATURE_COUNTER: begin
		enable_write_fm_wm_prod = 1'b1;
        	enable_read = 1'b0;
		// enable_write = 1'b0;
		enable_scratch_pad_weight = 1'b0;
        enable_scratch_pad_feature = 1'b0;
		enable_weight_counter = 1'b0;
		enable_feature_counter = 1'b1;
		read_feature_or_weight = 1'b1; 
        enable_accumulator = 1'b0;
		done = 1'b0;

		if (weight_count == WEIGHT_COLS - 1 && feature_count == FEATURE_ROWS - 1) begin
			next_state = DONE;
		end 
		else if (feature_count == FEATURE_ROWS - 1) begin
			next_state = INCREMENT_WEIGHT_COUNTER;
		end
		else  begin
			next_state = READ_FEATURE_DATA;
		end
      end

      DONE: begin
		enable_write_fm_wm_prod = 1'b0;
        	enable_read = 1'b0;
		// enable_write = 1'b0;
		enable_scratch_pad_weight = 1'b0;
		enable_scratch_pad_feature = 1'b0;
		enable_weight_counter = 1'b0;
		enable_feature_counter = 1'b0;
		read_feature_or_weight = 1'b0; 
        enable_accumulator = 1'b0;
		done = 1'b1;

		next_state = DONE;
      end

    endcase
  end

endmodule