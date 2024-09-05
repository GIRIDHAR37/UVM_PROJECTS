interface Interface (input logic clk);

  // Input clock signal
//  logic clk;

  // UART control and status signals
  logic Reset;              // Reset signal for initializing or resetting the UART
  logic rd_uart;            // Read UART control signal
  logic wr_uart;            // Write UART control signal
  logic [7:0] w_data;      // 8-bit data signal for writing to the UART
  logic [9:0] divsr;       // 10-bit divisor value for UART clock division
  logic rx_empty;          // Signal indicating if the RX buffer is empty
  logic tx_full;           // Signal indicating if the TX buffer is full
  logic rx;                // Signal for receiving data
  logic tx;                // Signal for transmitting data
  logic [7:0] r_data;     // 8-bit data signal received from UART
  logic correct_send;      // Signal indicating if the data was correctly sent

endinterface

