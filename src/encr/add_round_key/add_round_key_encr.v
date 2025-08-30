module add_round_key_encr(
    input [127:0] in_state,         
    input [127:0] round_key,    
    output reg [127:0] out_state 
);

    integer i, j;
    reg [7:0] state_matrix [0:3][0:3];
    reg [7:0] round_key_matrix [0:3][0:3];
    reg [7:0] result_matrix [0:3][0:3];
	// assign round_key = 128'hAC19285777FAD15C66DC2900F321415A;
    always @(*) begin    
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                state_matrix[i][j] = in_state[127 - ((i * 4 + j) * 8) -: 8];
                round_key_matrix[i][j] = round_key[127 - ((i * 4 + j) * 8) -: 8];
            end
        end
        
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                result_matrix[i][j] = state_matrix[i][j] ^ round_key_matrix[i][j];
            end
        end

        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                out_state[127 - ((i * 4 + j) * 8) -: 8] = result_matrix[i][j];
            end
        end
    end

endmodule