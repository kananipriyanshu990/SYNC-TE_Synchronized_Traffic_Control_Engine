`timescale 1ns/1ps

module SYNC_TE_TRAFFIC_CONTROLLER_TB;

    reg CLOCK_50;
    reg RESET;

    wire EAST_RED, EAST_YELLOW, EAST_GREEN;
    wire EAST_PED_RED, EAST_PED_GREEN;
    wire NORTH_RED, NORTH_YELLOW, NORTH_GREEN;
    wire NORTH_PED_RED, NORTH_PED_GREEN;
    wire WEST_RED, WEST_YELLOW, WEST_GREEN;
    wire WEST_PED_RED, WEST_PED_GREEN;
    wire SOUTH_RED, SOUTH_YELLOW, SOUTH_GREEN;
    wire SOUTH_PED_RED, SOUTH_PED_GREEN;

    // Accelerated simulation: 10 input-clock cycles represent one second.
    SYNC_TE_TRAFFIC_CONTROLLER #(.CLK_FREQ_HZ(10))
    TRF_CNTRL(.CLOCK_50(CLOCK_50),
              .RESET(RESET),

              .EAST_RED(EAST_RED),
              .EAST_YELLOW(EAST_YELLOW),
              .EAST_GREEN(EAST_GREEN),
              .EAST_PED_RED(EAST_PED_RED),
              .EAST_PED_GREEN(EAST_PED_GREEN),

              .NORTH_RED(NORTH_RED),
              .NORTH_YELLOW(NORTH_YELLOW),
              .NORTH_GREEN(NORTH_GREEN),
              .NORTH_PED_RED(NORTH_PED_RED),
              .NORTH_PED_GREEN(NORTH_PED_GREEN),

              .WEST_RED(WEST_RED),
              .WEST_YELLOW(WEST_YELLOW),
              .WEST_GREEN(WEST_GREEN),
              .WEST_PED_RED(WEST_PED_RED),
              .WEST_PED_GREEN(WEST_PED_GREEN),

              .SOUTH_RED(SOUTH_RED),
              .SOUTH_YELLOW(SOUTH_YELLOW),
              .SOUTH_GREEN(SOUTH_GREEN),
              .SOUTH_PED_RED(SOUTH_PED_RED),
              .SOUTH_PED_GREEN(SOUTH_PED_GREEN));

    // 20 ns clock period. The DUT's divider is shortened by its parameter.
    always #10 CLOCK_50 = ~CLOCK_50;

    initial begin
        CLOCK_50 = 1'b0;
        RESET = 1'b1;

        #50 RESET = 1'b0;

        // 52 seconds * 10 clock cycles/second * 20 ns/cycle = 10,400 ns.
        // Extra time shows the counter wrapping to zero and the cycle restarting.
        #10500 $finish;
    end

endmodule
