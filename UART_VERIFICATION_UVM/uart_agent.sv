class Agent extends uvm_agent;

  // Register the Agent class with UVM factory
  `uvm_component_utils(Agent)

  // Declare components of the Agent
  Monitor UART_monitor;
  Driver UART_driver;
  Sequencer UART_sequencer;
  Coverage_collector UART_coverage_collector;

  // Constructor
  function new(string name = "Agent", uvm_component parent);
    super.new(name, parent);  // Call the base class constructor
    `uvm_info(get_type_name(), "Inside constructor of Agent Class", UVM_LOW)  // Log info about the constructor
  endfunction 

  // Build phase: Create and configure the components
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);  // Call the base class build_phase

    `uvm_info(get_type_name(), "Inside build phase of Agent Class", UVM_LOW)  // Log info about the build phase
    
    // Create the components using UVM factory
    UART_monitor = Monitor::type_id::create("UART_monitor", this);
    UART_driver = Driver::type_id::create("UART_driver", this);
    UART_sequencer = Sequencer::type_id::create("UART_sequencer", this);
    UART_coverage_collector = Coverage_collector::type_id::create("UART_coverage_collector", this);
  endfunction 

  // Connect phase: Establish connections between components
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);  // Call the base class connect_phase

    `uvm_info(get_type_name(), "Inside connect phase of Agent Class", UVM_LOW)  // Log info about the connect phase
    
    // Connect the driver sequencer to the sequence item port
    UART_driver.seq_item_port.connect(UART_sequencer.seq_item_export);
    
    // Connect the monitor's analysis port to the coverage collector
    UART_monitor.monitor_port.connect(UART_coverage_collector.analysis_export);
  endfunction 

endclass

