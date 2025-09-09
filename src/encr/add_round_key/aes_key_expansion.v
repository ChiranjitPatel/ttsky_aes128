module aes_key_expand_128( key, key_array);
input	[127:0]	key;
output [1407:0] key_array;

reg	[31:0]	w0,w1,w2,w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17,
							w18, w19, w20, w21, w22, w23, w24, w25, w26, w27, w28, w29, w30, w31, w32, w33,
							w34, w35, w36, w37, w38, w39, w40, w41, w42, w43;
wire	[31:0]	subword, subword2,subword3,subword4,subword5, subword6, subword7,subword8,subword9,subword10;			

// reg [7:0] sbox [0:255]; // Declare the S-box as a 256-entry array

// // Initialize the S-box from a hex file
// initial begin
    // $readmemh("src/encr/sub_bytes/sbox.hex", sbox); // Point to your regular S-box file
// end

always @*
begin
 
w0 =  key[127:096];
w1 =  key[095:064];
w2 =  key[063:032];
w3 =  key[031:000];

w4 = key[127:96] ^ subword ^ 32'h01000000;  
w5 =  w4 ^ key[095:064];
w6 =  w5 ^ key[063:032];
w7 =  w6 ^ key[031:000];

w8 = w4 ^ subword2 ^ 32'h02000000;  
w9 = w8 ^ w5;
w10 = w9 ^ w6;
w11 = w10 ^ w7;


w12 = w8 ^ subword3 ^ 32'h04000000; 
w13 = w9 ^ w12;
w14 = w10 ^ w13;
w15 = w11 ^ w14;


w16 = w12 ^ subword4 ^ 32'h08000000;
w17 = w13 ^ w16; 
w18 = w14 ^ w17;
w19 = w15 ^ w18;


w20 = w16 ^ subword5 ^ 32'h10000000;
w21 = w17 ^ w20; 
w22 = w18 ^ w21;
w23 = w19 ^ w22;


w24 = w20 ^ subword6 ^ 32'h20000000;
w25 = w21 ^ w24;
w26 = w22 ^ w25;
w27 = w23 ^ w26;

w28 = w24 ^ subword7 ^ 32'h40000000; 
w29 = w25 ^ w28;
w30 = w26 ^ w29;
w31 = w27 ^ w30;

w32 = w28 ^ subword8 ^ 32'h80000000; 
w33 = w29 ^ w32;
w34 = w30 ^ w33;
w35 = w31 ^ w34;

w36 = w32 ^ subword9 ^ 32'h1b000000; 
w37 = w33 ^ w36; 
w38 = w34 ^ w37;
w39 = w35 ^ w38;

w40 = w36 ^ subword10 ^ 32'h36000000; // 
w41 = w37 ^ w40; 
w42 = w38 ^ w41;
w43 = w39 ^ w42;

end

// assign out_data[7:0]    = sbox[in_data[7:0]];

sbox u0(w3[23:16], subword[31:24]);  // Byte 2 (w3[23:16]) -> Byte 1 (subword[31:24])
sbox u1(w3[15:8], subword[23:16]);   // Byte 3 (w3[15:8]) -> Byte 2 (subword[23:16])
sbox u2(w3[7:0], subword[15:8]);     // Byte 4 (w3[7:0]) -> Byte 3 (subword[15:8])
sbox u3(w3[31:24], subword[7:0]);    // Byte 1 (w3[31:24]) -> Byte 4 (subword[7:0])  

sbox u4(w7[23:16], subword2[31:24]); 
sbox u5(w7[15:8], subword2[23:16]); 
sbox u6(w7[7:0], subword2[15:8]);   
sbox u7(w7[31:24], subword2[7:0]);    

sbox u8(w11[23:16], subword3[31:24]); 
sbox u9(w11[15:8], subword3[23:16]); 
sbox u10(w11[7:0], subword3[15:8]);  
sbox u11(w11[31:24], subword3[7:0]);    

sbox u12(w15[23:16], subword4[31:24]); 
sbox u13(w15[15:8], subword4[23:16]); 
sbox u14(w15[7:0], subword4[15:8]);  
sbox u15(w15[31:24], subword4[7:0]);    

sbox u16(w19[23:16], subword5[31:24]);
sbox u17(w19[15:8], subword5[23:16]); 
sbox u18(w19[7:0], subword5[15:8]);  
sbox u19(w19[31:24], subword5[7:0]);  

sbox u20(w23[23:16], subword6[31:24]); 
sbox u21(w23[15:8], subword6[23:16]); 
sbox u22(w23[7:0], subword6[15:8]);  
sbox u23(w23[31:24], subword6[7:0]);    

sbox u24(w27[23:16], subword7[31:24]);
sbox u25(w27[15:8], subword7[23:16]); 
sbox u26(w27[7:0], subword7[15:8]);   
sbox u27(w27[31:24], subword7[7:0]);     

sbox u28(w31[23:16], subword8[31:24]);
sbox u29(w31[15:8], subword8[23:16]); 
sbox u30(w31[7:0], subword8[15:8]);   
sbox u31(w31[31:24], subword8[7:0]);    

sbox u32(w35[23:16], subword9[31:24]); 
sbox u33(w35[15:8], subword9[23:16]); 
sbox u34(w35[7:0], subword9[15:8]); 
sbox u35(w35[31:24], subword9[7:0]);   

sbox u36(w39[23:16], subword10[31:24]); 
sbox u37(w39[15:8], subword10[23:16]); 
sbox u38(w39[7:0], subword10[15:8]);   
sbox u39(w39[31:24], subword10[7:0]);     

// assign w3[23:16] = sbox[subword[31:24]];  
// assign w3[15:8] = sbox[subword[23:16]]; 
// assign w3[7:0] = sbox[subword[15:8]];     
// assign w3[31:24] = sbox[subword[7:0]];  
 
// assign w7[23:16] = sbox[subword2[31:24]]; 
// assign w7[15:8] = sbox[subword2[23:16]]; 
// assign w7[7:0] = sbox[subword2[15:8]];   
// assign w7[31:24] = sbox[subword2[7:0]];    
 
// assign w11[23:16] = sbox[subword3[31:24]]; 
// assign w11[15:8] = sbox[subword3[23:16]]; 
// assign w11[7:0] = sbox[subword3[15:8]];  
// assign w11[31:24] = sbox[subword3[7:0]];    
 
// assign w15[23:16] = sbox[subword4[31:24]]; 
// assign w15[15:8] = sbox[subword4[23:16]]; 
// assign w15[7:0] = sbox[subword4[15:8]];  
// assign w15[31:24] = sbox[subword4[7:0]];    
 
// assign w19[23:16] = sbox[subword5[31:24]];
// assign w19[15:8] = sbox[subword5[23:16]]; 
// assign w19[7:0] = sbox[subword5[15:8]];  
// assign w19[31:24] = sbox[subword5[7:0]];  
 
// assign w23[23:16] = sbox[subword6[31:24]]; 
// assign w23[15:8] = sbox[subword6[23:16]]; 
// assign w23[7:0] = sbox[subword6[15:8]];  
// assign w23[31:24] = sbox[subword6[7:0]];    
 
// assign w27[23:16] = sbox[subword7[31:24]];
// assign w27[15:8] = sbox[subword7[23:16]]; 
// assign w27[7:0] = sbox[subword7[15:8]];   
// assign w27[31:24] = sbox[subword7[7:0]];     
 
// assign w31[23:16] = sbox[subword8[31:24]];
// assign w31[15:8] = sbox[subword8[23:16]]; 
// assign w31[7:0] = sbox[subword8[15:8]];   
// assign w31[31:24] = sbox[subword8[7:0]];    
 
// assign w35[23:16] = sbox[subword9[31:24]]; 
// assign w35[15:8] = sbox[subword9[23:16]]; 
// assign w35[7:0] = sbox[subword9[15:8]]; 
// assign w35[31:24] = sbox[subword9[7:0]];   
 
// assign w39[23:16] = sbox[subword10[31:24]]; 
// assign w39[15:8] = sbox[subword10[23:16]]; 
// assign w39[7:0] = sbox[subword10[15:8]];   
// assign w39[31:24] = sbox[subword10[7:0]]; 


assign key_array[127:0]={w0,w1,w2,w3};
assign key_array[255:128]={w4,w5,w6,w7};
assign key_array[383:256]={w8,w9,w10,w11};
assign key_array[511:384]={w12,w13,w14,w15};
assign key_array[639:512]={w16,w17,w18,w19};
assign key_array[767:640]={w20,w21,w22,w23};
assign key_array[895:768]={w24,w25,w26,w27};
assign key_array[1023:896]={w28,w29,w30,w31};
assign key_array[1151:1024]={w32,w33,w34,w35};
assign key_array[1279:1152]={w36,w37,w38,w39};
assign key_array[1407:1280]={w40,w41,w42,w43};

// assign key_array[127:0]     = {w40,w41,w42,w43};
// assign key_array[255:128]   = {w36,w37,w38,w39};
// assign key_array[383:256]   = {w32,w33,w34,w35};
// assign key_array[511:384]   = {w28,w29,w30,w31};
// assign key_array[639:512]   = {w24,w25,w26,w27};
// assign key_array[767:640]   = {w20,w21,w22,w23};
// assign key_array[895:768]   = {w16,w17,w18,w19};
// assign key_array[1023:896]  = {w12,w13,w14,w15};
// assign key_array[1151:1024] = {w8,w9,w10,w11};
// assign key_array[1279:1152] = {w4,w5,w6,w7};
// assign key_array[1407:1280] = {w0,w1,w2,w3};

endmodule