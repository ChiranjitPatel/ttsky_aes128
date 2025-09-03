/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

// `default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
  // tt_um_sub_bytes uut1 (.in_data(ui_in), .out_data(uo_out));
  
  tt_um_aes_core_uart uut 
	(
	.clk(clk),
	.reset(rst_n),
	.uart_rx(ui_in[0]),
	.aes_enable(ui_in[1]),
	.uart_tx(uo_out[0]),
	.frames_received(uo_out[1]),
	.uart_tx_ready(uo_out[2])
	);
	
	
  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 0;
  assign uio_oe  = 0;
  assign uo_out[7:3]  = 5'b0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule
