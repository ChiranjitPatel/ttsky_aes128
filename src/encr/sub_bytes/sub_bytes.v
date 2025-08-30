module sub_bytes (
    input [127:0] in_data,    // 128-bit input
    output [127:0] out_data   // 128-bit output
);
    reg [7:0] sbox [0:255]; // Declare the S-box as a 256-entry array

    // Initialize the S-box from a hex file
    initial begin
        $readmemh("C:/Users/ADMIN/Documents/GitHub/Advanced_Encryption_Std/encryption_9r/encryption_9r.srcs/sources_1/new/sub_bytes/sbox.hex", sbox); // Point to your regular S-box file
    end

    // Apply the S-box transformation to each byte of the input
    assign out_data[7:0]    = sbox[in_data[7:0]];
    assign out_data[15:8]   = sbox[in_data[15:8]];
    assign out_data[23:16]  = sbox[in_data[23:16]];
    assign out_data[31:24]  = sbox[in_data[31:24]];
    assign out_data[39:32]  = sbox[in_data[39:32]];
    assign out_data[47:40]  = sbox[in_data[47:40]];
    assign out_data[55:48]  = sbox[in_data[55:48]];
    assign out_data[63:56]  = sbox[in_data[63:56]];
    assign out_data[71:64]  = sbox[in_data[71:64]];
    assign out_data[79:72]  = sbox[in_data[79:72]];
    assign out_data[87:80]  = sbox[in_data[87:80]];
    assign out_data[95:88]  = sbox[in_data[95:88]];
    assign out_data[103:96] = sbox[in_data[103:96]];
    assign out_data[111:104] = sbox[in_data[111:104]];
    assign out_data[119:112] = sbox[in_data[119:112]];
    assign out_data[127:120] = sbox[in_data[127:120]];
endmodule
