module FIFO_Contr #(
    parameter addr_width = 5,
    parameter Read = 2'b01,
    parameter Write = 2'b10,
    parameter Read_and_Write = 2'b11
)(
    input logic clk,
    input logic Reset,
    input logic wr,
    input logic rd,
    output logic full,
    output logic empty,
    output logic [addr_width-2:0] w_addr,
    output logic [addr_width-2:0] r_addr
);

// Intermediate signals declaration
logic full_next, full_logic;
logic empty_next, empty_logic;
logic [addr_width-2:0] wr_ptr_next, wr_ptr_logic, wr_ptr_succ;
logic [addr_width-2:0] rd_ptr_next, rd_ptr_logic, rd_ptr_succ;

// Update the FIFO control unit state
always_ff @(posedge clk, posedge Reset) begin
    if (Reset) begin
        full_logic <= 1'b0;
        empty_logic <= 1'b1;
        wr_ptr_logic <= 0;
        rd_ptr_logic <= 0;
    end else begin
        full_logic <= full_next;
        empty_logic <= empty_next;
        wr_ptr_logic <= wr_ptr_next;
        rd_ptr_logic <= rd_ptr_next;
    end
end

// Next state logic
always_comb begin
    // Compute the next pointer values
    wr_ptr_succ = wr_ptr_logic + 1;
    rd_ptr_succ = rd_ptr_logic + 1;

    // Default values
    full_next = full_logic;
    empty_next = empty_logic;
    wr_ptr_next = wr_ptr_logic;
    rd_ptr_next = rd_ptr_logic;

    unique case ({wr, rd})
        Read: begin
            if (~empty_logic) begin // If FIFO is not empty
                rd_ptr_next = rd_ptr_succ; // Move to the next read address
                full_next = 1'b0;

                if (rd_ptr_succ == wr_ptr_logic) begin
                    empty_next = 1'b1; // FIFO becomes empty
                end
            end
        end

        Write: begin
            if (~full_logic) begin // If FIFO is not full
                wr_ptr_next = wr_ptr_succ; // Move to the next write address
                empty_next = 1'b0;

                if (wr_ptr_succ == rd_ptr_logic) begin
                    full_next = 1'b1; // FIFO becomes full
                end
            end
        end

        Read_and_Write: begin
            wr_ptr_next = wr_ptr_succ;
            rd_ptr_next = rd_ptr_succ;
        end

        default: begin
            // No operation
        end
    endcase
end

// Output assignments
assign full = full_logic;
assign empty = empty_logic;
assign w_addr = wr_ptr_logic;
assign r_addr = rd_ptr_logic;

endmodule

