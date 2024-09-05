class UART_seq_item extends uvm_sequence_item;

  // Register UART_seq_item class with the UVM factory
  `uvm_object_utils(UART_seq_item)

  // Data members
  rand logic Reset;            // Randomized logic signal for reset
  rand logic rd_uart;          // Randomized logic signal for read UART
  rand logic wr_uart;          // Randomized logic signal for write UART
  rand logic [7:0] w_data;    // Randomized 8-bit data for write
  rand logic [9:0] divsr;     // Randomized 10-bit divisor value
  logic rx_empty;             // Logic signal indicating RX buffer empty
  logic tx_full;              // Logic signal indicating TX buffer full
  logic tx;                   // Logic signal for TX data
  logic rx;                   // Logic signal for RX data
  logic [7:0] r_data;        // 8-bit data received from RX
  logic correct_send;         // Logic signal indicating if data was correctly sent

  // Constraint to ensure the divisor is always 650
  constraint c1 {
    divsr == 650;
  }

  // Constructor
  function new(string name = "UART_seq_item");
    super.new(name);  // Call base class constructor

    // Display message during construction
    `uvm_info(get_type_name(), "Inside constructor of UART seq item Class", UVM_HIGH)
  endfunction 
endclass 

