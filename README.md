# 📦 1x3 Router – RTL Design & UVM-Based Verification

This project implements a **1x3 packet-based router** using Verilog HDL and verifies it using the **UVM methodology** in SystemVerilog. The design routes incoming data to one of three output ports based on header information and uses ready/valid handshaking. The environment is fully testbench-driven with reusable UVM components.

---

## 📘 Project Overview

- **Router Type**: 1 input → 3 output
- **Header**: 2-bit field determines routing path
- **Design Language**: Verilog HDL
- **Verification**: UVM (SystemVerilog)
- **Tools Used**: Xilinx ISE (RTL), Siemens QuestaSim (Simulation)

---

## 🧠 Key Features

- FSM-based packet decoder
- Each output port has internal buffering (FIFO-style logic)
- Ready/Valid handshake protocol
- Full UVM-based environment:
  - Sequence, Driver, Monitor, Agent, Scoreboard, Environment
- Random and directed test generation
- Assertion-based checking
- Achieved **100% functional and code coverage**
