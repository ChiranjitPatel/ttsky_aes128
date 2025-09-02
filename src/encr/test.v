module tt_um_aes_core_uart 
  #(  
    parameter N = 128,
    parameter M = 9,
    parameter [23:0] BAUD_RATE = 24'd4000000,
    parameter [27:0] CLOCK_FREQ = 28'd50000000
  )
  (
    input clk,
    input reset,
    input uart_rx,
    input aes_enable,
    output reg uart_tx,
    output reg frames_received,
    output reg uart_tx_ready
  );

  localparam NUM_FRAMES = N/8;
  localparam DELAY_TIME = 100;
  localparam UART_TX_DELAY = 1000;
  localparam UART_TX_DELAY_BITS = 10; // Update according to $clog2(UART_TX_DELAY), here for 1024 cycles
  localparam NUM_FRAME_BITS = 4;      // Update as needed for NUM_FRAMES

  reg uart_clock_50M;
  // reg [N-1:0] plaintext;
  reg [N-1:0] secret_key;
  reg [N-1:0] encr_planetext_input;
  reg [N-1:0] encr_ciphertext_output;
  reg [7:0] key_frames [0:NUM_FRAMES-1];
  reg [7:0] rx_frames [0:NUM_FRAMES-1];

  // UART
  reg       uart_tx_start;
  reg [7:0] uart_transmit_data;
  reg [7:0] uart_received_data;
  reg       uart_rx_valid;
  reg       uart_rx_valid_edge;
  reg       uart_tx_ready_edge;
  reg [UART_TX_DELAY_BITS-1:0]  uart_tx_delay_count;
  reg [NUM_FRAME_BITS-1:0]      rx_frames_count;
  reg [NUM_FRAME_BITS:0]        tx_frames_count;
  reg [7:0] delay_count;

  // State Encoding for FSM
  localparam [2:0]
    Init          = 3'd0,
    Key_Rx_Frames = 3'd1,
    Rx_Frames     = 3'd2,
    Delay         = 3'd3,
    Tx_Data       = 3'd4,
    Tx_Delay      = 3'd5,
    Finish        = 3'd6;

  reg [2:0] state;

  // --- MAPPING FRAMES TO FLAT ARRAYS ---
  integer i;
  always @* begin
    for (i = 0; i < NUM_FRAMES; i = i + 1) begin
      encr_planetext_input[i*8 +: 8] = rx_frames[i];
      secret_key[i*8 +: 8] = key_frames[i];
    end
  end

  // --- SYNCHRONOUS LOGIC ---
  integer j;
  always @(posedge clk or negedge reset) begin
    if (~reset) begin
      frames_received <= 1'b0;
      uart_rx_valid_edge <= 1'b0;
      rx_frames_count <= 0;
      tx_frames_count <= 0;

      // Explicitly reset arrays:
      for (j = 0; j < NUM_FRAMES; j = j + 1) begin
        key_frames[j] <= 8'h00;
        rx_frames[j] <= 8'h00;
      end

      delay_count <= 8'b0;
      uart_tx_start <= 1'b0;
      uart_transmit_data <= 8'b0;
      uart_tx_ready_edge <= 1'b0;
      uart_tx_delay_count <= 0;
      state <= Init;
    end else begin
      case(state)
        Init: begin
          if (aes_enable) 
            state <= Key_Rx_Frames;
          else begin
            for (j = 0; j < NUM_FRAMES; j = j + 1) begin
              key_frames[j] <= 8'h00;
              rx_frames[j] <= 8'h00;
            end
            state <= Init;
          end
        end
        Key_Rx_Frames: begin
          uart_rx_valid_edge <= uart_rx_valid;
          if (~uart_rx_valid_edge & uart_rx_valid) begin
            key_frames[rx_frames_count] <= uart_received_data;
            if (rx_frames_count == (NUM_FRAMES-1)) begin
              rx_frames_count <= 0;
              frames_received <= 1'b1;
              state <= Rx_Frames;
            end else begin
              rx_frames_count <= rx_frames_count + 1'b1;
            end
          end else begin
            state <= Key_Rx_Frames;
          end
        end
        Rx_Frames: begin
          uart_rx_valid_edge <= uart_rx_valid;
          if (~uart_rx_valid_edge & uart_rx_valid) begin
            rx_frames[rx_frames_count] <= uart_received_data;
            if (rx_frames_count == (NUM_FRAMES-1)) begin
              rx_frames_count <= 0;
              frames_received <= 1'b1;
              state <= Delay;
            end else begin
              rx_frames_count <= rx_frames_count + 1'b1;
            end
          end else begin
            if (aes_enable)
              state <= Rx_Frames;
            else begin
              frames_received <= 1'b0;
              state <= Init;
            end
          end
        end
        Delay: begin
          if (delay_count == DELAY_TIME) begin
            delay_count <= 8'b0;
            state <= Tx_Data;
          end else begin
            delay_count <= delay_count + 1'b1;
          end
        end
        Tx_Data: begin
          uart_tx_ready_edge <= uart_tx_ready;
          if (uart_tx_ready) begin
            if ((~uart_tx_ready_edge & uart_tx_ready) == 1'b1) begin
              uart_tx_start <= 1'b0;
              uart_transmit_data <= 8'b0;
              if (tx_frames_count == NUM_FRAMES) begin
                tx_frames_count <= 0;
                state <= Finish;
              end else begin
                state <= Tx_Delay;
              end
            end else begin
              uart_tx_start <= 1'b1;
              uart_transmit_data <= encr_ciphertext_output[tx_frames_count*8+:8];
            end
          end else begin
            if ((uart_tx_ready_edge & ~uart_tx_ready) == 1'b1) begin
              uart_tx_start <= 1'b0;
              tx_frames_count <= tx_frames_count + 1'b1;
            end else begin
              state <= Tx_Data;
            end
          end
        end
        Tx_Delay: begin
          if (uart_tx_delay_count == UART_TX_DELAY) begin
            uart_tx_delay_count <= 0;
            state <= Tx_Data;
          end else begin
            uart_tx_delay_count <= uart_tx_delay_count + 1'b1;
          end
        end
        Finish: begin
          if (aes_enable)
            state <= Rx_Frames;
          else begin
            frames_received <= 1'b0;
            state <= Init;
          end
        end
        default: state <= Init;
      endcase
    end
  end
endmodule
