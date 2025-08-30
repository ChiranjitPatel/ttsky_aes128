module mix_columns(
    input  [127:0] state_in,  
    output [127:0] state_out  
);

    wire [7:0] s [3:0][3:0];
    
    assign {s[0][0], s[1][0], s[2][0], s[3][0], 
            s[0][1], s[1][1], s[2][1], s[3][1], 
            s[0][2], s[1][2], s[2][2], s[3][2], 
            s[0][3], s[1][3], s[2][3], s[3][3]} = state_in;
            
    wire [7:0] m [3:0][3:0];
    genvar i;
    genvar j;
    generate
        for (i = 0; i < 4; i = i + 1) begin : col
            for (j = 0; j < 4; j = j + 1) begin : row
                assign m[i][j] = mul2(s[i][j]) ^ mul3(s[(i + 1) % 4][j]) ^ s[(i + 2) % 4][j] ^ s[(i + 3) % 4][j];
            end
        end
    endgenerate
    
    assign state_out = {m[0][0], m[1][0], m[2][0], m[3][0], 
                        m[0][1], m[1][1], m[2][1], m[3][1], 
                        m[0][2], m[1][2], m[2][2], m[3][2], 
                        m[0][3], m[1][3], m[2][3], m[3][3]};
                        
    function [7:0] mul2(input [7:0] x);
        mul2 = (x << 1) ^ (8'h1b & {8{x[7]}}); 
    endfunction

   
    function [7:0] mul3(input [7:0] x);
        mul3 = mul2(x) ^ x;
    endfunction

endmodule
