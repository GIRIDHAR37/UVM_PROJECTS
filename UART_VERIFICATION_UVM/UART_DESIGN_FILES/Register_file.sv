module Register_file #(
    parameter addr_width = 5,
    parameter Data_bits = 9
)(
    input clk,
    input w_en,
    input [Data_bits-2:0] w_data,
    input [addr_width-2:0] w_addr,
    input [addr_width-2:0] r_addr,
    output logic [Data_bits-2:0] r_data
);

// Define the register file, which is a memory array
logic [Data_bits-2:0] reg_file [0:2**addr_width-1];

// Write operation
always_ff @(posedge clk) begin
    if (w_en) begin
        reg_file[w_addr] <= w_data; // Write data to the register file at the write address
    end
end

// Read operation
assign r_data = reg_file[r_addr]; // Read data from the register file at the read address

endmodule

