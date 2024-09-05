class Driver extends uvm_driver #(UART_seq_item);

  // Register Driver with UVM factory
  `uvm_component_utils(Driver)

  // Declare a virtual interface handle
  virtual Interface intf;
  
  // Declare a handle for UART sequence item
  UART_seq_item item;

  // Constructor
  function new(string name = "Driver", uvm_component parent);
    super.new(name, parent);  // Call the base class constructor
    `uvm_info(get_type_name(), "Inside constructor of Driver Class", UVM_LOW)  // Log message in the constructor
  endfunction 
  // Build phase: Initializes the virtual interface and other setup
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);  // Call the base class build_phase

    `uvm_info(get_type_name(), "Inside build phase of Driver Class", UVM_LOW)  // Log message in the build phase
    
    // Get the virtual interface from the UVM configuration database
    if (!(uvm_config_db #(virtual Interface)::get(this, "*", "intf", intf))) 
      `uvm_error(get_type_name(), "Failed to get virtual interface inside Driver class")  // Log error if virtual interface is not retrieved
  endfunction 

  // Connect phase (optional for the driver)
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  // Call the base class connect_phase
    `uvm_info(get_type_name(), "Inside connect phase of Driver Class", UVM_LOW)  // Log message in the connect phase
  endfunction 

  // Run phase: Main loop to get items from the sequencer and drive them to DUT
  task run_phase(uvm_phase phase);
    super.run_phase(phase);  // Call the base class run_phase

    `uvm_info(get_type_name(), "Inside run phase of Driver Class", UVM_LOW)  // Log message in the run phase
    
    forever begin
      item = UART_seq_item::type_id::create("item");  // Create a sequence item
      seq_item_port.get_next_item(item);  // Get the next item from the sequencer
      drive(item);  // Call the drive task to send the transaction to the DUT
      seq_item_port.item_done();  // Indicate that the item has been processed
    end
  endtask 

  // Drive task: Drives the signals to the DUT based on the sequence item
  task drive(UART_seq_item item);
    // Set the interface signals based on the sequence item
    intf.Reset = item.Reset;
    intf.rd_uart = item.rd_uart;
    intf.wr_uart = item.wr_uart;
    intf.w_data = item.w_data;
    intf.divsr = item.divsr;

    // Simulate UART transmission when read or write is enabled
    if ((!(item.rd_uart) && (item.wr_uart)) || (!(item.rd_uart) && (!item.wr_uart))) begin
      intf.rx = 1;  // Set rx to 1 (idle state)
    end

    if ((item.rd_uart && !(item.wr_uart)) || ((item.rd_uart) && (item.wr_uart))) begin
      // UART transmission starts when rd_uart or both rd_uart and wr_uart are enabled

      // Start bit (0)
      intf.rx = 0;
      repeat(5000) @(posedge intf.clk);  // Wait for start bit duration

      // Transmit data bits (8 bits)
      foreach (item.w_data[i]) begin
        intf.rx = item.w_data[i];  // Send each bit from the sequence item data
        repeat(10000) @(posedge intf.clk);  // Wait for the bit duration
      end

      // Parity bit (even parity)
      if (^item.w_data)  // XOR of data bits to calculate parity
        intf.rx = 1;  // Set parity bit to 1
      else
        intf.rx = 0;  // Set parity bit to 0

      repeat(10000) @(posedge intf.clk);  // Wait for the parity bit duration

      // Stop bit (1)
      intf.rx = 1;
      repeat(10000) @(posedge intf.clk);  // Wait for stop bit duration
    end

    // Wait for the time between frames when writing or not reading
    if ((!item.rd_uart && item.wr_uart) || (!item.rd_uart && !item.wr_uart)) begin
      repeat(104000) @(posedge intf.clk);  // Wait for one frame duration
    end
  endtask 
endclass

