class Environment extends uvm_env;

  // Register the Environment class with UVM factory
  `uvm_component_utils(Environment)
  
  // Declare the UART agent instance
  Agent UART_Agent;

  // Constructor for the Environment class
  function new(string name = "Environment", uvm_component parent);
    super.new(name, parent);  // Call the base class constructor
    `uvm_info(get_type_name(), "Inside constructor of Environment Class", UVM_LOW)
  endfunction 
  // Build phase: create and configure components
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);  // Call the base class build_phase
    `uvm_info(get_type_name(), "Inside build phase of Environment Class", UVM_LOW)
    
    // Create the UART agent using the UVM factory
    UART_Agent = Agent::type_id::create("UART_Agent", this);
  endfunction 

  // Connect phase: connect components if necessary
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  // Call the base class connect_phase
    `uvm_info(get_type_name(), "Inside connect phase of Environment Class", UVM_LOW)
  endfunction : connect_phase

endclass 

