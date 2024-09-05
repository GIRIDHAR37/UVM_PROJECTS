class UART_Test extends uvm_test;

  `uvm_component_utils(UART_Test)

  // Declare the environment and sequences used in the test
  Environment UART_environment;
  Reset_seq reset_seq;
  UART_seq seq;

  // Constructor of the UART_Test class
  function new(string name = "UART_Test", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "Inside constructor of UART Test Class", UVM_LOW)
  endfunction 

  // Build phase: create the environment
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Inside build phase of UART Test Class", UVM_LOW)
    
    // Create the environment
    UART_environment = Environment::type_id::create("UART_environment", this);
  endfunction 

  // Connect phase: connect components, if necessary
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "Inside connect phase of UART Test Class", UVM_LOW)
  endfunction 

  // Run phase: where the actual test execution happens
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "Inside run phase of UART Test Class", UVM_LOW)
    
    // Raise an objection to keep the simulation running
    phase.raise_objection(this);

    // Apply the reset sequence after a delay
    #100000;
    reset_seq = Reset_seq::type_id::create("reset_seq");
    reset_seq.start(UART_environment.UART_Agent.UART_sequencer);

    // Repeat sending sequences 1000 times, with a delay between each
    repeat(1000) begin
      #970000;
      seq = UART_seq::type_id::create("seq");
      seq.start(UART_environment.UART_Agent.UART_sequencer);
    end

    // Drop the objection to end the simulation
    phase.drop_objection(this);
  endtask 

endclass 
