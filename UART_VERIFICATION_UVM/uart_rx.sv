`include "Register_file.sv"

module UART_RX #(
    parameter Data_bits = 9,     // Including parity bit
    parameter Sp_ticks = 16,     // Stop bit ticks
    parameter St_ticks = 8,      // Start bit ticks
    parameter Dt_ticks = 16      // Data ticks for receiving one data bit
)(
    input rx,
    input clk, Reset,
    input s_ticks,
    
    output logic rx_done_tick,
    output [Data_bits-2:0] data_out,
    output logic correct_send  // Indicates if the received data is correct (1) or has an error (0)
);

typedef enum { idle, start, data, stop } S_states;

S_states state_reg, state_next;            // To keep track of the current and next state
logic [$clog2(Dt_ticks)-1:0] s_reg, s_next; // To keep track of the number of ticks
logic [$clog2(Data_bits)-1:0] n_reg, n_next; // To keep track of the number of received bits
logic [Data_bits-2:0] sd_reg, sd_next;     // Data to be shifted
logic parity_reg, parity_next;             // Parity bit register

always_ff @(posedge clk, posedge Reset) begin
    if (Reset) begin  // Reset is active high
        state_reg <= idle;
        s_reg <= 0;
        n_reg <= 0;
        sd_reg <= 0;
        parity_reg <= 0;
    end else begin
        state_reg <= state_next;
        s_reg <= s_next;
        n_reg <= n_next;
        sd_reg <= sd_next;
        parity_reg <= parity_next;
    end
end

always_comb begin
    state_next = state_reg;
    s_next = s_reg;
    n_next = n_reg;
    sd_next = sd_reg;
    parity_next = parity_reg;
    rx_done_tick = 1'b0;
    correct_send = 1'b0;

    case (state_reg)
        idle: begin
            if (~rx) begin  // Start bit detected (rx goes low)
                s_next = 0;
                state_next = start;
            end
        end

        start: begin
            if (s_ticks) begin
                if (s_next == St_ticks-1) begin
                    s_next = 0;
                    n_next = 0;
                    state_next = data;
                end else begin
                    s_next = s_reg + 1;
                end
            end
        end

        data: begin
            if (s_ticks) begin
                if (s_next == Dt_ticks-1) begin
                    sd_next = {rx, sd_reg[Data_bits-2:1]};
                    s_next = 0;
                    parity_next = parity_next ^ rx;
                    
                    if (n_reg == Data_bits-1) begin
                        state_next = stop;
                        correct_send = (parity_reg == rx);
                    end else begin
                        n_next = n_reg + 1;
                    end
                end else begin
                    s_next = s_reg + 1;
                end
            end
        end

        stop: begin
            if (s_ticks) begin
                if (s_next == Sp_ticks-1) begin
                    state_next = idle;
                    rx_done_tick = 1'b1;  // Receiving bits was successfully done
                end else begin
                    s_next = s_reg + 1;
                end
            end
        end

        default: state_next = idle;
    endcase
end

assign data_out = sd_reg;  // Assign the received data bits

endmodule

