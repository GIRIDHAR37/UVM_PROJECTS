#compilation
vlog top.sv\
+incdir+E:/UVM/uvm-1.2/uvm-1.2/src 
#ellaboration + mapping uvm dpi
vsim Top\
-novopt -suppress 12110\
-sv_lib E:/Questasim/Q\ inner\ files/uvm-1.2/win64/uvm_dpi\
+UVM_TESTNAME=UART_Test 
#ADD WAVEFORM
add wave -position insertpoint sim:/Top/intf/*
#simulation
run -all
