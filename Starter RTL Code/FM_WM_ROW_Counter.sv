module FM_WM_ROW_Counter (
    input logic clk,
    input logic reset,
    input logic done_trans,
    output logic [2:0] coo_address
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            coo_address <= 3'd0;
        end else if (done_trans) begin
            if (coo_address == 3'd5)
                coo_address <= 3'd5;
            else
                coo_address <= coo_address + 3'd1;
        end
    end
    
endmodule