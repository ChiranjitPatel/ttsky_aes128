module encryption_block #(parameter N=128, parameter M=1) 
(
	clk,
	encr_planetext_input,
	secret_key,
	encr_ciphertext_output
);

	input clk;
	input  [N-1:0] encr_planetext_input ;
	input  [N-1:0] secret_key ;
	output [N-1:0] encr_ciphertext_output;
	
	wire [N-1:0] secret_key;
	wire [(M+1)*N-1:0] chiper_stg;
	wire [N*(M+2)-1:0] key_for_each_round;

	genvar stage;
	
	aes_key_expand_128 key_gen (.key(secret_key), .key_array(key_for_each_round));

	add_round_key_encr arkzero (.in_state(encr_planetext_input), .round_key(key_for_each_round[N-1:0]), .out_state(chiper_stg[N-1:0]) );
	
	generate
		for (stage=1; stage < M+1 ; stage=stage+1) begin : encr_loop
			encryption_sub_block1 encr_n (.clk(clk), .round_key(key_for_each_round[(stage+1)*N-1:(stage)*N]), .input_text(chiper_stg[stage*N-1:(stage-1)*N]), .output_text(chiper_stg[(stage+1)*N-1:(stage)*N]) );
			
			// for M=1 rounds
			// encryption_sub_block1 encr_n (.clk(clk), .round_key(key_for_each_round[(stage+1)*N-1:(stage)*N]), .input_text(chiper_stg[stage*N-1:(stage-1)*N]), .output_text(encr_ciphertext_output[N-1:0]) );
		end
		
		
	endgenerate
	
	// assign encr_ciphertext_output[N-1:0] = chiper_stg[(M+1)*N-1:(M)*N];  // for M=2 rounds, for M=1 comment this line and the encr_2 below line

	encryption_sub_block2 encr_2 (.clk(clk), .round_key(key_for_each_round[N*(M+2)-1:N*(M+1)]), .input_text(chiper_stg[(M+1)*N-1:M*N]), .output_text(encr_ciphertext_output) );

endmodule

