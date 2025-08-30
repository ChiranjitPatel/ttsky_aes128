module MixColumns_tb;

    reg [127:0] state_in;       
    wire [127:0] state_out;     

    MixColumns uut (
        .state_in(state_in),
        .state_out(state_out)
    );

    initial begin

        state_in = 128'hd4bf5d30e0b452aeb84111f11e2798e5;
        #10; 
        $display("Input : %h", state_in);
        $display("Output: %h", state_out);

        state_in = 128'h04088d4f2635a62e0637a3a51415b05e;
        #10;
        $display("Input : %h", state_in);
        $display("Output: %h", state_out);

        state_in = 128'hd0a361e536c930406061a2f40e09380e;
        #10;
        $display("Input : %h", state_in);
        $display("Output: %h", state_out);

        $finish;
    end
endmodule
