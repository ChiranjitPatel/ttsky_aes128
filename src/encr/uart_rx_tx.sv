// `timescale 1ns / 1ps

module uart_rx_tx 
	#(  parameter [23:0] BAUD_RATE = 24'd4000000,
		parameter [27:0] CLOCK_FREQ = 28'd50000000
	)
	(	
		// clk_10ns,
		uart_clock,
		uart_reset,
		uart_transmit_data,
		uart_rx_d_in,
		uart_tx_start,
		uart_tx_d_out,
		uart_received_data,
		uart_rx_valid,
		uart_tx_ready
	);
	
	
	// input  logic clk_10ns;
	input  logic uart_clock;
	input  logic uart_reset;
	input  logic [7:0] uart_transmit_data;
	input  logic uart_rx_d_in;
	input  logic uart_tx_start;
	output logic uart_tx_d_out;
	output logic [7:0] uart_received_data;
	output logic uart_rx_valid;
	output logic uart_tx_ready;
	

	// logic uart_clock_10M;
	// logic locked;
	// logic [2:0] count_rx_frames;
	logic [7:0] uart_rx_frames [2:0];
	// logic uart_rx_valid_edge;
	
	
	// Instantiate clock Wizard
	// clk_wiz_1 clk_wiz_inst (
        // .clk_out1(uart_clock_10M),
        // .reset(1'b0),
        // .locked(locked),
        // .clk_in1(clk_10ns)
    // );

	// Instantiate uart_tx
	uart_tx 
	#(
		.baud_rate(BAUD_RATE),
		.clock_freq(CLOCK_FREQ)
	) 
	uart_tx_inst (
		.uart_clock(uart_clock),
		.uart_reset(uart_reset),
		.uart_start(uart_tx_start),
		.uart_d_in(uart_transmit_data),
		.uart_d_out(uart_tx_d_out),
		.uart_tx_ready(uart_tx_ready)
	);

	// Instantiate uart_rx 
	uart_rx 
	#(
		.baud_rate(BAUD_RATE),
		.clock_freq(CLOCK_FREQ)
	) 
	uart_rx_inst (
		.uart_clock(uart_clock),
		.uart_reset(uart_reset),
		.uart_d_in(uart_rx_d_in),
		.uart_d_out(uart_received_data),
		.uart_valid(uart_rx_valid)
	);

	// always_ff @(posedge clk_10ns or negedge uart_reset) begin
		// if (!uart_reset) begin
			// count_rx_frames <= 3'b0;
			// uart_rx_frames <= '{3{8'h00}};
		// end
		// else begin
			// uart_rx_valid_edge <= uart_rx_valid;
			// if (~uart_rx_valid_edge & uart_rx_valid) begin
				// uart_rx_frames[count_rx_frames] <= uart_received_data;
				// if (count_rx_frames == 3)
					// count_rx_frames <= 3'b0;
				// else
					// count_rx_frames <= count_rx_frames + 1'b1;
			// end
		// end
				
		
			// if (uart_tx_ready) begin
				// // Set transmit data
				// // uart_tx_data <= uart_transmit_data;
				// if (delay_count <= 400) begin
				    // delay_count <= delay_count + 1'b1;
				// end
				// else begin
				    // delay_count <= 0;
				    // uart_tx_data <= uart_transmit_data ? 8'h31 : 8'h30; 
				    // uart_tx_start <= 1'b1;
				// end
			// end 
			// else begin
				// uart_tx_start <= 1'b0;
			// end
		// end
	// end

endmodule
