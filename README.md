# Pipelined ALU in Verilog

## Overview

This project implements a fully synthesizable 32-bit Pipelined Arithmetic Logic Unit (ALU) using Verilog HDL. The design follows a modular RTL methodology and demonstrates how instructions, operands, control signals, addresses, and status flags can be coordinated through a multi-stage pipeline architecture.

The project was developed as a digital design and RTL engineering exercise with a strong emphasis on clean architecture, modularity, verification, documentation, and industry-style design practices.

---

## Features

* 32-bit datapath
* Multi-stage pipelined architecture
* Modular RTL implementation
* Dedicated Control Unit
* Dual-read, single-write Register File
* Pipeline Registers between stages
* Status Flag Generation

  * Carry Flag
  * Overflow Flag
  * Zero Flag
  * Negative Flag
* SystemVerilog Verification Environment
* Fully Synthesizable Design
* Detailed Design Documentation

---

## Supported Operations

| Opcode | Operation                |
| ------ | ------------------------ |
| 0000   | Buffer A                 |
| 0001   | Buffer B                 |
| 0010   | Addition                 |
| 0011   | Subtraction              |
| 0100   | Logical Shift Right A    |
| 0101   | Logical Shift Right B    |
| 0110   | Arithmetic Shift Right A |
| 0111   | Arithmetic Shift Right B |
| 1000   | Shift Left A             |
| 1001   | Shift Left B             |
| 1010   | Bitwise AND              |
| 1011   | Bitwise OR               |
| 1100   | Bitwise XOR              |
| 1101   | Bitwise Inversion A      |
| 1110   | Bitwise Inversion B      |
| 1111   | Compare                  |

---

## Architecture

The design is divided into multiple independent RTL blocks:

### Control Unit

Decodes instructions, generates control signals, manages register addressing, and coordinates pipeline activity.

### Register File

Stores operands and computed results. Supports two simultaneous read ports and one write port.

### Pipeline Registers

Separate adjacent pipeline stages and maintain synchronization between control information and datapath information.

### ALU Core

Performs arithmetic, logical, shift, inversion, and comparison operations while generating status flags.

### Top-Level Integration Module

Connects all submodules and forms the complete pipelined processing system.

---

## Pipeline Flow

### Stage 1 — Instruction Decode

* Instruction received
* Opcode extracted
* Source and destination addresses decoded

### Stage 2 — Operand Fetch

* Operands read from Register File
* Values stored in pipeline registers

### Stage 3 — Execute

* ALU operation performed
* Status flags generated

### Stage 4 — Writeback

* Result written into destination register
* Instruction execution completed

Multiple instructions may occupy different stages simultaneously, improving throughput compared to a non-pipelined implementation.

---

## Status Flags

### Carry Flag

Indicates unsigned carry generation during arithmetic operations.

### Overflow Flag

Indicates signed arithmetic overflow.

### Zero Flag

Asserted when the ALU result equals zero.

### Negative Flag

Reflects the sign bit of the ALU result.

---

## Verification

The project has been verified using SystemVerilog testbenches at both module level and top level.

Verification includes:

* Instruction decoding
* Register file read/write operations
* Pipeline synchronization
* ALU functionality
* Flag generation
* Writeback behavior
* Reset operation
* Integration testing

Waveform analysis was performed to validate timing relationships between operands, addresses, results, and control signals.

---

## Project Structure

```text
PIPELINED_ALU/
│
├── RTL/
│   ├── ALU.v
│   ├── CONTROL_UNIT.v
│   ├── REGISTER_FILE.v
│   ├── PIPELINE_REGISTER.v
│   └── PIPELINED_ALU.v
│
├── TB/
│   └── PIPELINED_ALU_TB.sv
│
├── Documentation/
│   ├── Project Description
│   ├── ALU Description
│   ├── Control Unit Description
│   ├── Register File Description
│   ├── Pipeline Architecture Description
│   ├── Testbench Description
│   └── Architecture and Dataflow Description
│
├── Waveforms/
│
└── README.md
```

---

## Tools Used

* Verilog HDL
* SystemVerilog
* GTKWave
* Icarus Verilog
* Yosys (Synthesis)

---

## Learning Outcomes

This project provided practical experience in:

* RTL Design
* Pipelined Architectures
* Control Path Design
* Datapath Design
* Register File Design
* Status Flag Generation
* SystemVerilog Verification
* Debugging with Waveforms
* Hardware Synthesis
* Technical Documentation

---

## Future Improvements

Potential extensions include:

* Hazard Detection Logic
* Data Forwarding
* Variable Shift Operations
* Parameterized Data Width
* Performance Optimization
* Advanced Verification Environment
* FPGA Implementation

---

## Author

Priyanshu Kanani

B.Tech Electronics and Communication Engineering

RTL Design | Digital Design | Verification | VLSI
