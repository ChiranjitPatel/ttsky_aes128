module shift_rows(
    input clk,
    input [127:0] state,       // Flattened 4x4 matrix input (128 bits)
    output reg [127:0] shifted_state // Flattened 4x4 matrix output (128 bits)
);

always @(posedge clk) begin
    // // Row 0 (No shift)
    // shifted_state[127:120] <= state[127:120];
    // shifted_state[119:112] <= state[119:112];
    // shifted_state[111:104] <= state[111:104];
    // shifted_state[103:96] <= state[103:96];
    
    // // Row 1 (Left shift by 1)
    // shifted_state[95:88] <= state[87:80];
    // shifted_state[87:80] <= state[79:72];
    // shifted_state[79:72] <= state[71:64];
    // shifted_state[71:64] <= state[95:88];
    
    // // Row 2 (Left shift by 2)
    // shifted_state[63:56] <= state[47:40];
    // shifted_state[55:48] <= state[39:32];
    // shifted_state[47:40] <= state[63:56];
    // shifted_state[39:32] <= state[55:48];
    
    // // Row 3 (Left shift by 3)
    // shifted_state[31:24] <= state[7:0];
    // shifted_state[23:16] <= state[31:24];
    // shifted_state[15:8] <= state[23:16];
    // shifted_state[7:0] <= state[15:8];
	
	    // Row-wise ShiftRows transformation
    shifted_state[127:120] <= state[127:120]; // Row 0, no shift
    shifted_state[119:112] <= state[87:80];   // Row 1, left shift by 1
    shifted_state[111:104] <= state[47:40];   // Row 2, left shift by 2
    shifted_state[103:96]  <= state[7:0];     // Row 3, left shift by 3
						   
    shifted_state[95:88]   <= state[95:88];   // Row 0, no shift
    shifted_state[87:80]   <= state[55:48];   // Row 1, left shift by 1
    shifted_state[79:72]   <= state[15:8];    // Row 2, left shift by 2
    shifted_state[71:64]   <= state[103:96];  // Row 3, left shift by 3
						   
    shifted_state[63:56]   <= state[63:56];   // Row 0, no shift
    shifted_state[55:48]   <= state[23:16];   // Row 1, left shift by 1
    shifted_state[47:40]   <= state[111:104]; // Row 2, left shift by 2
    shifted_state[39:32]   <= state[71:64];   // Row 3, left shift by 3
						   
    shifted_state[31:24]   <= state[31:24];   // Row 0, no shift
    shifted_state[23:16]   <= state[119:112]; // Row 1, left shift by 1
    shifted_state[15:8]    <= state[79:72];   // Row 2, left shift by 2
    shifted_state[7:0]     <= state[39:32];   // Row 3, left shift by 3
	
	
end

endmodule


