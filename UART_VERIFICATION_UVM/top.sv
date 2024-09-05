import uvm_pkg::*;
`include "uvm_pkg.sv"

`include "uart_intf.sv"
`include "uart_trans.sv"
`include "uart_cov.sv"
`include "uart_mon.sv"
`include "uart_seq.sv"
`include "uart_sqr.sv"
`include "uart_drv.sv"
`include "uart_agent.sv"
`include "uart_env.sv" 
`include "uart_test.sv"
`include "uart.sv"

module Top();

    logic clk;

    // Instantiate the interface, connecting the clock signal
    Interface intf(.clk(clk));

    // Instantiate the UART DUT (Device Under Test), connecting signals from the interface
    UART DUT (
        .clk(intf.clk),
        .Reset(intf.Reset),
        .rd_uart(intf.rd_uart),
        .wr_uart(intf.wr_uart),
        .w_data(intf.w_data),
        .divsr(intf.divsr),
        .rx_empty(intf.rx_empty),
        .tx_full(intf.tx_full),
        .tx(intf.tx),
        .rx(intf.rx),
        .r_data(intf.r_data),
        .correct_send(intf.correct_send)
    );

    // Clock generation process
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Testbench setup
    initial begin
        // Set up the UVM configuration database with a virtual interface
        uvm_config_db #(virtual Interface)::set(null, "*", "intf", intf);

        // Run the UVM test
        run_test("UART_Test");
    end

    // Simulation termination
    initial begin
        #200000000; // Run the simulation for a fixed time duration
        $finish();  // Finish the simulation
    end

endmodule

// output :
/*
# UVM_INFO uart_test.sv(13) @ 0: uvm_test_top [UART_Test] Inside constructor of UART Test Class
# UVM_INFO @ 0: reporter [RNTST] Running test UART_Test...
# UVM_INFO uart_test.sv(19) @ 0: uvm_test_top [UART_Test] Inside build phase of UART Test Class
# UVM_INFO uart_env.sv(12) @ 0: uvm_test_top.UART_environment [Environment] Inside constructor of Environment Class
# UVM_INFO uart_env.sv(17) @ 0: uvm_test_top.UART_environment [Environment] Inside build phase of Environment Class
# UVM_INFO uart_agent.sv(15) @ 0: uvm_test_top.UART_environment.UART_Agent [Agent] Inside constructor of Agent Class
# UVM_INFO uart_agent.sv(22) @ 0: uvm_test_top.UART_environment.UART_Agent [Agent] Inside build phase of Agent Class
# UVM_INFO uart_mon.sv(21) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_monitor [Monitor] Inside constructor of Monitor Class
# UVM_INFO uart_drv.sv(15) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_driver [Driver] Inside constructor of Driver Class
# UVM_INFO uart_sqr.sv(9) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_sequencer [Sequencer] Inside constructor of Sequencer Class
# UVM_INFO uart_cov.sv(50) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_coverage_collector [Coverage_collector] Inside constructor of coverage collector Class
# UVM_INFO uart_cov.sv(61) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_coverage_collector [Coverage_collector] Inside build phase of coverage collector Class
# UVM_INFO uart_drv.sv(21) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_driver [Driver] Inside build phase of Driver Class
# UVM_INFO uart_mon.sv(29) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_monitor [Monitor] Inside build phase of Monitor Class
# UVM_INFO uart_sqr.sv(14) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_sequencer [Sequencer] Inside build phase of Sequencer Class
# UVM_INFO uart_cov.sv(69) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_coverage_collector [Coverage_collector] Inside connect phase of coverage collector Class
# UVM_INFO uart_drv.sv(31) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_driver [Driver] Inside connect phase of Driver Class
# UVM_INFO uart_mon.sv(44) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_monitor [Monitor] Inside connect phase of Monitor Class
# UVM_INFO uart_sqr.sv(20) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_sequencer [Sequencer] Inside connect phase of Sequencer Class
# UVM_INFO uart_agent.sv(35) @ 0: uvm_test_top.UART_environment.UART_Agent [Agent] Inside connect phase of Agent Class
# UVM_INFO uart_env.sv(26) @ 0: uvm_test_top.UART_environment [Environment] Inside connect phase of Environment Class
# UVM_INFO uart_test.sv(28) @ 0: uvm_test_top [UART_Test] Inside connect phase of UART Test Class
# UVM_INFO uart_test.sv(34) @ 0: uvm_test_top [UART_Test] Inside run phase of UART Test Class
# UVM_INFO uart_sqr.sv(26) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_sequencer [Sequencer] Inside run phase of Sequencer Class
# UVM_INFO uart_mon.sv(52) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_monitor [Monitor] Inside run phase of Monitor Class
# UVM_INFO uart_drv.sv(38) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_driver [Driver] Inside run phase of Driver Class
# UVM_INFO uart_cov.sv(77) @ 0: uvm_test_top.UART_environment.UART_Agent.UART_coverage_collector [Coverage_collector] Inside run phase of coverage collector Class
# ** Note: $finish    : top.sv(57)
#    Time: 200 ms  Iteration: 0  Instance: /Top
*/

