// `timescale 1ns/1ps

module tt_um_aes_core_uart 
	#(  
		parameter N = 128,
		parameter M = 9,
		parameter [23:0] BAUD_RATE = 24'd4000000,
        parameter [27:0] CLOCK_FREQ = 28'd50000000
    )
	(
	clk,
	reset,
	uart_rx,
	aes_enable,
	uart_tx,
	frames_received,
	uart_tx_ready

	);

	input logic clk;
	input logic reset;
	input logic uart_rx;
	input logic aes_enable;
	output logic uart_tx;
	output logic frames_received;
	output logic uart_tx_ready;

	localparam integer NUM_FRAMES = (N)/8;
	localparam integer DELAY_TIME = 100;
	localparam integer UART_TX_DELAY = 1000;
	localparam integer UART_TX_DELAY_BITS = $clog2(UART_TX_DELAY);
	localparam integer NUM_FRAME_BITS = $clog2(NUM_FRAMES);

	logic uart_clock_50M;

	// logic [N-1:0] plaintext;
	logic [N-1:0] secret_key;
	logic [N-1:0] encr_planetext_input;
	logic [N-1:0] encr_ciphertext_output;
	
	logic [7:0] key_frames [NUM_FRAMES-1:0];
	logic [7:0] rx_frames [NUM_FRAMES-1:0];
	
	// UART
    logic       uart_tx_start;
    logic [7:0] uart_transmit_data;
    logic [7:0] uart_received_data;
    logic       uart_rx_valid;
    // logic       uart_tx_ready;
	logic       uart_rx_valid_edge;
	logic 		uart_tx_ready_edge;
	logic [UART_TX_DELAY_BITS-1:0]  uart_tx_delay_count;
	
	logic [NUM_FRAME_BITS-1:0]    rx_frames_count;
	logic [NUM_FRAME_BITS:0]    tx_frames_count;
	logic [7:0] delay_count;
	
	typedef enum logic[2:0] {Init, Key_Rx_Frames, Rx_Frames, Delay, Tx_Data, Tx_Delay, Finish} state_machine;
    state_machine state;
	
	// // Instantiate clock Wizard
	// clk_wiz_0 clk_wiz_inst (
        // .clk_out1(uart_clock_50M),
        // .reset(1'b0),
        // .clk_in1(clk)
    // );

	
	// Instantiate the uart_rx_tx module
    uart_rx_tx #(
        .BAUD_RATE(BAUD_RATE),
        .CLOCK_FREQ(CLOCK_FREQ)
    ) uut1 (
        // .clk_10ns(clk),
        .uart_clock(clk),
        .uart_reset(reset),
        .uart_transmit_data(uart_transmit_data),
        .uart_rx_d_in(uart_rx),
        .uart_tx_start(uart_tx_start),
        .uart_tx_d_out(uart_tx),
        .uart_received_data(uart_received_data),
        .uart_rx_valid(uart_rx_valid),
        .uart_tx_ready(uart_tx_ready)
    );

	encryption_block #(.N(N), .M(M)) encr_1 (.clk(clk), .secret_key(secret_key), .encr_planetext_input(encr_planetext_input), .encr_ciphertext_output(encr_ciphertext_output) );
	// decryption_block #(.N(N), .M(M)) decr_1 (.clk(clk), .ciphertext_in(ciphertext), .secret_key(secret_key), .plaintext_out(plaintext_out) );
	
	always_comb begin
		//direct mapping possible?
		encr_planetext_input[7:0] 		= rx_frames[0]; 
		encr_planetext_input[15:8] 		= rx_frames[1]; 
		encr_planetext_input[23:16] 	= rx_frames[2]; 
		encr_planetext_input[31:24] 	= rx_frames[3]; 
		encr_planetext_input[39:32] 	= rx_frames[4]; 
		encr_planetext_input[47:40] 	= rx_frames[5]; 
		encr_planetext_input[55:48] 	= rx_frames[6]; 
		encr_planetext_input[63:56] 	= rx_frames[7]; 
		encr_planetext_input[71:64] 	= rx_frames[8]; 
		encr_planetext_input[79:72] 	= rx_frames[9]; 
		encr_planetext_input[87:80] 	= rx_frames[10]; 
		encr_planetext_input[95:88] 	= rx_frames[11]; 
		encr_planetext_input[103:96] 	= rx_frames[12]; 
		encr_planetext_input[111:104] 	= rx_frames[13]; 
		encr_planetext_input[119:112] 	= rx_frames[14]; 
		encr_planetext_input[127:120] 	= rx_frames[15];

		secret_key[7:0] 	= key_frames[0];  
		secret_key[15:8] 	= key_frames[1];  
		secret_key[23:16] 	= key_frames[2];  
		secret_key[31:24] 	= key_frames[3];  
		secret_key[39:32] 	= key_frames[4];  
		secret_key[47:40] 	= key_frames[5];  
		secret_key[55:48] 	= key_frames[6];  
		secret_key[63:56] 	= key_frames[7];  
		secret_key[71:64] 	= key_frames[8];  
		secret_key[79:72] 	= key_frames[9];  
		secret_key[87:80] 	= key_frames[10]; 
		secret_key[95:88] 	= key_frames[11]; 
		secret_key[103:96] 	= key_frames[12]; 
		secret_key[111:104] = key_frames[13]; 
		secret_key[119:112] = key_frames[14]; 
		secret_key[127:120] = key_frames[15]; 
	end
	
	always_ff @(posedge clk or negedge reset) begin
	
		if (~reset) begin
			frames_received <= 1'b0;
			uart_rx_valid_edge <= 0;
			rx_frames_count <= 5'b0;
			tx_frames_count <= 0;
			key_frames <= '{NUM_FRAMES{8'h00}};
			rx_frames <= '{NUM_FRAMES{8'h00}};
			delay_count <= 8'b0;
			uart_tx_start <= 1'b0;
			uart_transmit_data <= 8'b0;
			uart_tx_ready_edge <= 0;
			uart_tx_delay_count <= 0;
			state <= Init;
		end
	
		else begin
			case(state)
				Init			:	begin
										if (aes_enable) 
											state <= Key_Rx_Frames;
										else begin
											key_frames <= '{NUM_FRAMES{8'h00}};
											rx_frames <= '{NUM_FRAMES{8'h00}};
											state <= Init;
										end
									end
				
				Key_Rx_Frames   :	begin
										uart_rx_valid_edge <= uart_rx_valid;
										if (~uart_rx_valid_edge & uart_rx_valid) begin
											key_frames[rx_frames_count] <= uart_received_data;
											if (rx_frames_count == (NUM_FRAMES-1)) begin
												rx_frames_count <= 0;
												frames_received <= 1'b1;
												state <= Rx_Frames;
											end
											else
												rx_frames_count <= rx_frames_count + 1'b1;
										end
										else
											state <= Key_Rx_Frames;
									end
		
				Rx_Frames   	:	begin
										uart_rx_valid_edge <= uart_rx_valid;
										if (~uart_rx_valid_edge & uart_rx_valid) begin
											rx_frames[rx_frames_count] <= uart_received_data;
											if (rx_frames_count == (NUM_FRAMES-1)) begin
												rx_frames_count <= 0;
												frames_received <= 1'b1;
												state <= Delay;
											end
											else
												rx_frames_count <= rx_frames_count + 1'b1;
										end
										else begin
											if (aes_enable)
												state <= Rx_Frames;
											else begin
												frames_received <= 1'b0;
												state <= Init;
											end
										end
									end
								
							
				Delay   		:	begin
										if (delay_count == DELAY_TIME) begin
											delay_count <= 8'b0;
											state <= Tx_Data;
										end
										else
											delay_count <= delay_count + 1'b1;
									end
	
				Tx_Data			:	begin
										uart_tx_ready_edge <= uart_tx_ready;
										
										if (uart_tx_ready) begin
											if ((~uart_tx_ready_edge & uart_tx_ready) == 1) begin
												uart_tx_start <= 1'b0;
												uart_transmit_data <= 0;
												if (tx_frames_count == NUM_FRAMES) begin
													tx_frames_count <= 0;
													state <= Finish;
												end
												else begin
													state <= Tx_Delay;
												end
											end
											
											else begin
												uart_tx_start <= 1'b1;
												uart_transmit_data <= encr_ciphertext_output[tx_frames_count * 8 +: 8];
												// uart_transmit_data <= plaintext_out[tx_frames_count * 8 +: 8];
											end
										end
										
										else begin
											if ((uart_tx_ready_edge & ~uart_tx_ready) == 1) begin
												uart_tx_start <= 1'b0;
												tx_frames_count <= tx_frames_count + 1'b1;
											end
											else
												state <= Tx_Data;
										end
									end
				
				Tx_Delay		:	begin
										if (uart_tx_delay_count == UART_TX_DELAY) begin
											uart_tx_delay_count <= 0;
											state <= Tx_Data;
										end
										else
											uart_tx_delay_count <= uart_tx_delay_count + 1'b1;
									end
	
				Finish			:	begin
										if (aes_enable)
											state <= Rx_Frames;
										else begin
											frames_received <= 1'b0;
											state <= Init;
										end
									end
				
				default			:	state <= Init;
	
				
			endcase
		end
	end
endmodule
