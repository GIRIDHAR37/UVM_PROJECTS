class Coverage_collector extends uvm_subscriber #(UART_seq_item);

  // Register Coverage_collector class with the UVM factory
  `uvm_component_utils(Coverage_collector)

  // Sequence item to hold the data received from the monitor
  UART_seq_item item;

  // Coverage group to collect coverage data
  covergroup UART_cover_signals;

    // Coverage for read UART signal
    rd_uart_cov: coverpoint item.rd_uart;

    // Coverage for write UART signal
    wr_uart_cov: coverpoint item.wr_uart;

    // Coverage for write data, including parity
    w_data_cov: coverpoint item.w_data[7:0] {
      // Bin for data with odd parity
      bins wdata_with_odd_parity = {[127:0]} iff ($countones(item.w_data) % 2 == 1);
      // Bin for data with even parity
      bins wdata_with_even_parity = {[127:0]} iff ($countones(item.w_data) % 2 == 0);
    }

    // Coverage for TX full signal
    tx_full_cov: coverpoint item.tx_full;

    // Coverage for TX signal
    tx_cov: coverpoint item.tx;

    // Coverage for received data, including parity
    r_data_cov: coverpoint item.r_data[7:0] {
      // Bin for received data with odd parity
      bins rdata_with_odd_parity = {[127:0]} iff ($countones(item.r_data) % 2 == 1);
      // Bin for received data with even parity
      bins rdata_with_even_parity = {[127:0]} iff ($countones(item.r_data) % 2 == 0);
    }

    // Cross coverage between read and write signals
    cross_rd_wr: cross rd_uart_cov, wr_uart_cov;

  endgroup

  // Constructor
  function new(string name = "Coverage_collector", uvm_component parent);
    super.new(name, parent);  // Call base class constructor

    // Display message during construction
    `uvm_info(get_type_name(), "Inside constructor of coverage collector Class", UVM_LOW)

    // Create a new instance of the coverage group
    UART_cover_signals = new();
  endfunction 

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);  // Call base class build phase

    // Display message during build phase
    `uvm_info(get_type_name(), "Inside build phase of coverage collector Class", UVM_LOW)
  endfunction 

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  // Call base class connect phase

    // Display message during connect phase
    `uvm_info(get_type_name(), "Inside connect phase of coverage collector Class", UVM_LOW)
  endfunction

  // Run phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);  // Call base class run phase

    // Display message during run phase
    `uvm_info(get_type_name(), "Inside run phase of coverage collector Class", UVM_LOW)
  endtask 

  // Write function to handle incoming sequence items
  function void write(UART_seq_item t);
    item = UART_seq_item::type_id::create("item");  // Create a new instance of UART_seq_item
    $cast(item, t);  // Cast the passed item to the local item

    // Sample the coverage group with the current item data
    UART_cover_signals.sample();
  endfunction 
endclass 

