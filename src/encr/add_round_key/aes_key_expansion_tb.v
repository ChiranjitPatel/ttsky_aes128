// `timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: G R Pradyumna Maiya
//
// Create Date: 16-11-24
// Design Name: 
// Module Name: aes_key_expand_128_tb
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Testbench for AES key expansion module
//
// Dependencies: aes_key_expand_128.v
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module aes_key_expand_128_tb();

    // Inputs
    reg [127:0] key;

    // Outputs
    wire [1408:0] key_array;

    // Split key_array into 11 separate 128-bit segments
    wire [127:0] key_part0;
    wire [127:0] key_part1;
    wire [127:0] key_part2;
    wire [127:0] key_part3;
    wire [127:0] key_part4;
    wire [127:0] key_part5;
    wire [127:0] key_part6;
    wire [127:0] key_part7;
    wire [127:0] key_part8;
    wire [127:0] key_part9;
    wire [127:0] key_part10;

    assign key_part0 = key_array[127:0];
    assign key_part1 = key_array[255:128];
    assign key_part2 = key_array[383:256];
    assign key_part3 = key_array[511:384];
    assign key_part4 = key_array[639:512];
    assign key_part5 = key_array[767:640];
    assign key_part6 = key_array[895:768];
    assign key_part7 = key_array[1023:896];
    assign key_part8 = key_array[1151:1024];
    assign key_part9 = key_array[1279:1152];
    assign key_part10 = key_array[1408:1280];

    // Instantiate the Unit Under Test (UUT)
    aes_key_expand_128 uut (
        .key(key),
        .key_array(key_array)
    );

    // Test vectors
    initial begin
        // Initialize inputs
        key = 128'hAC19285777FAD15C66DC2900F321415A; // Example key
        
        // Wait for some time to observe outputs
        #100;
        $display("Key: %h", key);
        $display("Key Part 0: %h", key_part0);
        $display("Key Part 1: %h", key_part1);
        $display("Key Part 2: %h", key_part2);
        $display("Key Part 3: %h", key_part3);
        $display("Key Part 4: %h", key_part4);
        $display("Key Part 5: %h", key_part5);
        $display("Key Part 6: %h", key_part6);
        $display("Key Part 7: %h", key_part7);
        $display("Key Part 8: %h", key_part8);
        $display("Key Part 9: %h", key_part9);
        $display("Key Part 10: %h", key_part10);

        // // Test with another key
        // key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        
        // // Wait for some time to observe outputs
        // #100;
        // $display("Key: %h", key);
        // $display("Key Part 0: %h", key_part0);
        // $display("Key Part 1: %h", key_part1);
        // $display("Key Part 2: %h", key_part2);
        // $display("Key Part 3: %h", key_part3);
        // $display("Key Part 4: %h", key_part4);
        // $display("Key Part 5: %h", key_part5);
        // $display("Key Part 6: %h", key_part6);
        // $display("Key Part 7: %h", key_part7);
        // $display("Key Part 8: %h", key_part8);
        // $display("Key Part 9: %h", key_part9);
        // $display("Key Part 10: %h", key_part10);

        // // Finish simulation
        // #50;
        // $finish;
    end

    // Optional: Monitor changes to inputs and outputs
    initial begin
        $monitor("At time %t: Key = %h", $time, key);
    end

endmodule
