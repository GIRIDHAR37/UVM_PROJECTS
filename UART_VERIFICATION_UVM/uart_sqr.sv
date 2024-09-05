class Sequencer extends uvm_sequencer #(UART_seq_item);

  // Register Sequencer with UVM factory
  `uvm_component_utils(Sequencer)

  // Constructor
  function new(string name = "Sequencer", uvm_component parent);
    super.new(name, parent);  // Call the base class constructor
    `uvm_info(get_type_name(), "Inside constructor of Sequencer Class", UVM_LOW)  // Log message in the constructor
  endfunction 
  // Build phase: Basic setup, mostly empty for a sequencer
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);  // Call the base class build_phase
    `uvm_info(get_type_name(), "Inside build phase of Sequencer Class", UVM_LOW)  // Log message in the build phase
  endfunction 

  // Connect phase: Mostly empty for a sequencer
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  // Call the base class connect_phase
    `uvm_info(get_type_name(), "Inside connect phase of Sequencer Class", UVM_LOW)  // Log message in the connect phase
  endfunction 

  // Run phase: Not used for sequencer but logs a message for completeness
  task run_phase(uvm_phase phase);
    super.run_phase(phase);  // Call the base class run_phase
    `uvm_info(get_type_name(), "Inside run phase of Sequencer Class", UVM_LOW)  // Log message in the run phase
  endtask 

endclass 
