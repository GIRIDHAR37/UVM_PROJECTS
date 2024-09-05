class Monitor extends uvm_monitor;

  // Register Monitor class with the UVM factory
  `uvm_component_utils(Monitor)

  // Virtual interface to connect with the DUT's signals
  virtual Interface intf;

  // UVM analysis port to pass data from the monitor to other components like a scoreboard or coverage collector
  uvm_analysis_port #(UART_seq_item) monitor_port;

  // UART sequence item to store the transaction observed by the monitor
  UART_seq_item item;

  // Constructor
  function new(string name = "Monitor", uvm_component parent);
    // Call the base class constructor
    super.new(name, parent);

    // Display message during construction
    `uvm_info(get_type_name(), "Inside constructor of Monitor Class", UVM_LOW)
  endfunction 

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);  // Call base class build phase
    
    // Display message during build phase
    `uvm_info(get_type_name(), "Inside build phase of Monitor Class", UVM_LOW)
    
    // Get the virtual interface from the UVM configuration database
    if (!(uvm_config_db #(virtual Interface)::get(this, "*", "intf", intf)))
      `uvm_error(get_type_name(), "failed to get virtual interface inside Monitor class")
    
    // Create the analysis port to transmit observed transactions
    monitor_port = new("monitor_port", this);
  endfunction 

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  // Call base class connect phase
    
    // Display message during connect phase
    `uvm_info(get_type_name(), "Inside connect phase of Monitor Class", UVM_LOW)
  endfunction 

  // Run phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);  // Call base class run phase
    
    // Display message during run phase
    `uvm_info(get_type_name(), "Inside run phase of Monitor Class", UVM_LOW)
    
    // Infinite loop to monitor UART transactions
    forever begin
      // Wait for Reset signal to go low
      wait(!intf.Reset);

      // Wait for some clock cycles after the Reset signal
      repeat(120000) @(posedge intf.clk);

      // Capture the current signal values from the DUT into the sequence item
      item = UART_seq_item::type_id::create("item");
      item.Reset = intf.Reset;
      item.rd_uart = intf.rd_uart;
      item.wr_uart = intf.wr_uart;
      item.w_data = intf.w_data;
      item.divsr = intf.divsr;
      item.rx_empty = intf.rx_empty;
      item.tx_full = intf.tx_full;
      item.tx = intf.tx;
      item.r_data = intf.r_data;
      item.correct_send = intf.correct_send;

      // Write the observed item to the analysis port
      monitor_port.write(item);
    end
  endtask 
endclass 

