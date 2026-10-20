# SYNC-TE — Synchronized Traffic Control Engine

SYNC-TE is an FPGA-based traffic light controller that uses a **single global cycle counter and combinational logic** to coordinate vehicle and pedestrian signals across four directions. Unlike conventional FSM-based controllers, SYNC-TE follows a predefined, time-based control chart to determine every signal's state simultaneously.

## Key Features

- **Counter-Driven Architecture:** A single 6-bit counter tracks the 52-second traffic cycle, counting from 0 to 51 before automatically resetting to zero.
- **Combinational Signal Control:** All vehicle and pedestrian outputs are decoded directly from the global counter.
- **Four-Direction Coordination:** Controls traffic signals for North, South, East, and West.
- **Pedestrian Signal Integration:** Coordinates pedestrian RED and GREEN signals according to a predefined schedule.
- **Deterministic Timing:** Follows a fixed control chart with predefined signal intervals.
- **No FSM:** Eliminates state-transition logic in favor of direct counter-based output decoding.
- **Simulation-Ready:** Includes a waveform-oriented testbench for observing the complete traffic cycle.

## Hardware and Tools

| Component | Specification |
|---|---|
| Target FPGA Board | Terasic DE1 |
| FPGA Device | Intel/Altera Cyclone II EP2C20F484C7 |
| HDL | Verilog |
| Simulation | Vivado Simulator |
| Hardware Implementation | Intel Quartus II |
| Clock Source | 50 MHz onboard oscillator |
| Cycle Counter | 6-bit |
| Total Cycle Duration | 52 seconds |

## Architecture

The design consists of two primary functional blocks within a single Verilog module:

1. **Global Cycle Counter:** Uses the onboard clock and a clock divider to advance the cycle counter once per second.
2. **Combinational Decoder:** Determines the ON/OFF state of every vehicle and pedestrian light from the current counter value.

The complete sequence repeats automatically after 52 seconds. All signal outputs are controlled by the same counter, ensuring coordinated operation according to the defined timing chart.

## Signal Outputs

The controller provides five outputs for each direction:

- Vehicle RED
- Vehicle YELLOW
- Vehicle GREEN
- Pedestrian RED
- Pedestrian GREEN

This gives a total of **20 independently controlled signal outputs** across the four directions.
