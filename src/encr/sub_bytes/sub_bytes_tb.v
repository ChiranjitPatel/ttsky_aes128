module tb_SubBytes128;

    // Testbench signals
    reg [127:0] in_data;     // 128-bit input data
    wire [127:0] out_data;   // 128-bit output data

    // Instantiate the SubBytes128 module
    SubBytes128 uut (
        .in_data(in_data),
        .out_data(out_data)
    );

    // Initial block to apply test cases
    initial begin
        // Apply the first input data
        in_data = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;  // First input data
        #100;  // Wait for 10 time units

        // Display the input and output data for verification
        $display("Input Data: %h", in_data);
        $display("Output Data: %h", out_data);

        // End the simulation after the first test
        $finish;
    end

endmodule
