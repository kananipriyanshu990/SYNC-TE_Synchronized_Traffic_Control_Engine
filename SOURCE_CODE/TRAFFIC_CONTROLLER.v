`timescale 1ns/1ps

module SYNC_TE_TRAFFIC_CONTROLLER #(
    parameter integer CLK_FREQ_HZ = 50000000
) (
    input  wire CLOCK_50,
    input  wire RESET,

    output reg EAST_RED,
    output reg EAST_YELLOW,
    output reg EAST_GREEN,
    output reg EAST_PED_RED,
    output reg EAST_PED_GREEN,

    output reg NORTH_RED,
    output reg NORTH_YELLOW,
    output reg NORTH_GREEN,
    output reg NORTH_PED_RED,
    output reg NORTH_PED_GREEN,

    output reg WEST_RED,
    output reg WEST_YELLOW,
    output reg WEST_GREEN,
    output reg WEST_PED_RED,
    output reg WEST_PED_GREEN,

    output reg SOUTH_RED,
    output reg SOUTH_YELLOW,
    output reg SOUTH_GREEN,
    output reg SOUTH_PED_RED,
    output reg SOUTH_PED_GREEN
);

    // A 6-bit counter represents the 52 one-second intervals: 0 through 51.
    reg [5:0] cycle_counter;
    integer clock_divider;

    // Advance the global cycle counter once per second.
    // CLK_FREQ_HZ is set to 50,000,000 for the physical DE1 board.
    always @(posedge CLOCK_50) begin
        if (RESET) begin
            clock_divider <= 0;
            cycle_counter <= 6'd0;
        end
        else if (clock_divider >= CLK_FREQ_HZ - 1) begin
            clock_divider <= 0;

            if (cycle_counter == 6'd51)
                cycle_counter <= 6'd0;
            else
                cycle_counter <= cycle_counter + 1'b1;
        end
        else begin
            clock_divider <= clock_divider + 1;
        end
    end

    // All outputs are decoded combinationally from the same global counter.
    // Output value 1 means ON; 0 means OFF. The chart's exact combinations
    // are preserved, including rows where RED and YELLOW are both ON.
    always @(*) begin
        EAST_RED = 1'b1; EAST_YELLOW = 1'b0; EAST_GREEN = 1'b0;
        EAST_PED_RED = 1'b1; EAST_PED_GREEN = 1'b0;
        NORTH_RED = 1'b1; NORTH_YELLOW = 1'b0; NORTH_GREEN = 1'b0;
        NORTH_PED_RED = 1'b1; NORTH_PED_GREEN = 1'b0;
        WEST_RED = 1'b1; WEST_YELLOW = 1'b0; WEST_GREEN = 1'b0;
        WEST_PED_RED = 1'b1; WEST_PED_GREEN = 1'b0;
        SOUTH_RED = 1'b1; SOUTH_YELLOW = 1'b0; SOUTH_GREEN = 1'b0;
        SOUTH_PED_RED = 1'b1; SOUTH_PED_GREEN = 1'b0;

        case (cycle_counter)
            // Chart row 1: duration 1 s, counter 0
            6'd0: begin end

            // Chart row 2: duration 2 s, counters 1-2
            6'd1, 6'd2: begin
                EAST_RED = 1'b0; EAST_YELLOW = 1'b1;
                NORTH_YELLOW = 1'b1;
            end

            // Chart row 3: duration 10 s, counters 3-12
            6'd3, 6'd4, 6'd5, 6'd6, 6'd7,
            6'd8, 6'd9, 6'd10, 6'd11, 6'd12: begin
                EAST_RED = 1'b0; EAST_GREEN = 1'b1;
                SOUTH_PED_RED = 1'b0; SOUTH_PED_GREEN = 1'b1;
            end

            // Chart row 4: duration 2 s, counters 13-14
            6'd13, 6'd14: begin
                EAST_RED = 1'b0; EAST_YELLOW = 1'b1;
                NORTH_RED = 1'b0; NORTH_YELLOW = 1'b1;
            end

            // Chart row 5: duration 10 s, counters 15-24
            6'd15, 6'd16, 6'd17, 6'd18, 6'd19,
            6'd20, 6'd21, 6'd22, 6'd23, 6'd24: begin
                EAST_PED_RED = 1'b0; EAST_PED_GREEN = 1'b1;
                NORTH_RED = 1'b0; NORTH_GREEN = 1'b1;
            end

            // Chart row 6: duration 2 s, counters 25-26
            6'd25, 6'd26: begin
                NORTH_RED = 1'b0; NORTH_YELLOW = 1'b1;
                WEST_RED = 1'b0; WEST_YELLOW = 1'b1;
            end

            // Chart row 7: duration 10 s, counters 27-36
            6'd27, 6'd28, 6'd29, 6'd30, 6'd31,
            6'd32, 6'd33, 6'd34, 6'd35, 6'd36: begin
                NORTH_PED_RED = 1'b0; NORTH_PED_GREEN = 1'b1;
                WEST_RED = 1'b0; WEST_GREEN = 1'b1;
            end

            // Chart row 8: duration 2 s, counters 37-38
            6'd37, 6'd38: begin
                WEST_RED = 1'b0; WEST_YELLOW = 1'b1;
                SOUTH_RED = 1'b0; SOUTH_YELLOW = 1'b1;
            end

            // Chart row 9: duration 10 s, counters 39-48
            6'd39, 6'd40, 6'd41, 6'd42, 6'd43,
            6'd44, 6'd45, 6'd46, 6'd47, 6'd48: begin
                WEST_PED_RED = 1'b0; WEST_PED_GREEN = 1'b1;
                SOUTH_RED = 1'b0; SOUTH_GREEN = 1'b1;
            end

            // Chart row 10: duration 2 s, counters 49-50
            6'd49, 6'd50: begin
                SOUTH_RED = 1'b0; SOUTH_YELLOW = 1'b1;
            end

            // Chart row 11: duration 1 s, counter 51
            6'd51: begin end

            default: begin end
        endcase
    end

endmodule
