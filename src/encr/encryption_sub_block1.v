module encryption_sub_block1 (
	clk,
	round_key,
	input_text,
	output_text
);

	input clk;
	input [127:0] round_key;
	input  [127:0] input_text ;
	output [127:0] output_text;
	
	wire [127:0] sub_blk_Stg1;
	wire [127:0] sub_blk_Stg2;
	wire [127:0] sub_blk_Stg3;
	
	sub_bytes sub1 (input_text, sub_blk_Stg1);
	shift_rows sftrows1 (clk, sub_blk_Stg1, sub_blk_Stg2);
	mix_columns mxcolmns1 (sub_blk_Stg2, sub_blk_Stg3);
	add_round_key_encr arkone (sub_blk_Stg3, round_key, output_text);

endmodule

