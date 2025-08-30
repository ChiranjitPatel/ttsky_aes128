`timescale 1ns / 1ps

module add_round_key_encr_tb;

    // Inputs
    reg [127:0] state;
    reg [127:0] round_key;

    // Output
    wire [127:0] out_state;

    // Instantiate the Unit Under Test (UUT)
    add_round_key_encr uut (
        .in_state(state),
        .round_key(round_key),
        .out_state(out_state)
    );

    initial begin
        // Initialize inputs
        state = 128'hc9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9;  
        round_key = 128'hac19285777fad15c66dc2900f321415a;

        // Wait for the outputs to settle
        #10;

        // Display the result
        $display("State:      %h", state);
        $display("Round Key:  %h", round_key);
        $display("Out State:  %h", out_state);

        // Finish simulation
        #10;
        $finish;
    end

endmodule