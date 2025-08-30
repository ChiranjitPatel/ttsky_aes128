`timescale 1ns / 1ps

module tb_shift_rows;

    // Inputs
    reg clk;
    reg [127:0] state;

    // Outputs
    wire [127:0] shifted_state;

    // Instantiate the shift_rows module
    shift_rows uut (
        .clk(clk),
        .state(state),
        .shifted_state(shifted_state)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock with 10ns period
    end

    // Test stimulus
    initial begin
        // Test vector 1: Sample input matrix (flattened)
        state = 128'h00112233445566778899aabbccddeeff; // Example AES state matrix
        
        // Wait for one clock cycle to observe output
        #10;

        // Display the results
        $display("Time: %0t | Input State: %h | Shifted State: %h",
                 $time, state, shifted_state);

        // Test vector 2: Another input matrix
        state = 128'hd4e0b81e27bfb44111985d52aef1e530; // Another example input matrix
        
        // Wait for one clock cycle to observe output
        #10;

        // Display the results
        $display("Time: %0t | Input State: %h | Shifted State: %h",
                 $time, state, shifted_state);

        // Finish simulation
        #20 $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %0t | Input State: %h | Shifted State: %h",
                 $time, state, shifted_state);
    end

endmodule
