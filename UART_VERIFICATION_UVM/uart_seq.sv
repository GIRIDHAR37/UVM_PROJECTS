class Base_sequence extends uvm_sequence #(UART_seq_item);

  // Register Base_sequence with the UVM factory
  `uvm_object_utils(Base_sequence)
   
  // Constructor
  function new(string name = "Base_sequence");
    super.new(name);  // Call the base class constructor
  endfunction: new

endclass: Base_sequence

////////////////////////////////////////////
// Reset_seq: Handles the reset operation //
////////////////////////////////////////////

class Reset_seq extends Base_sequence;

  // Register Reset_seq with the UVM factory
  `uvm_object_utils(Reset_seq)
  
  // UART sequence item object to be used in the reset sequence
  UART_seq_item reset_item;

  // Constructor
  function new(string name = "Reset_seq");
    super.new(name);  // Call the base class constructor
  endfunction
  
  // Main sequence task
  task body();
    // Create a new UART_seq_item for reset
    reset_item = UART_seq_item::type_id::create("reset_item");

    // Start the reset transaction
    start_item(reset_item);

    // Randomize the reset_item with specific constraints
    if (!(reset_item.randomize() with { Reset == 1; w_data == 8'b0; wr_uart == 0; rd_uart == 0; }))
      `uvm_error(get_type_name(), "randomization failed in Reset_seq");

    // Finish the reset transaction
    finish_item(reset_item);
  endtask
endclass

////////////////////////////////////////////
// UART_seq: Handles normal UART operation //
////////////////////////////////////////////

class UART_seq extends Base_sequence;

  // Register UART_seq with the UVM factory
  `uvm_object_utils(UART_seq)
  
  // UART sequence item object to be used in the UART sequence
  UART_seq_item item;

  // Constructor
  function new(string name = "UART_seq");
    super.new(name);  // Call the base class constructor
  endfunction
  
  // Main sequence task
  task body();
    // Create a new UART_seq_item for normal UART transaction
    item = UART_seq_item::type_id::create("item");

    // Start the UART transaction
    start_item(item);

    // Randomize the UART sequence item with specific constraints
    if (!(item.randomize() with { Reset == 0; }))
      `uvm_error(get_type_name(), "randomization failed in UART_seq");

    // Finish the UART transaction
    finish_item(item);
  endtask

endclass

