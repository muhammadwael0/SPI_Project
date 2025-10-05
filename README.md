# SPI Slave System

## 🧩 Overview

This project implements a **complete SPI Slave system** integrated with an **SP-RAM** and a **SPI Wrapper**.
It was developed as the **final project** for the *Digital IC Design Diploma* to demonstrate a full FPGA design flow — from RTL design and verification to FPGA synthesis, implementation, and testing.

The system allows communication between an SPI Slave and an internal RAM block through a custom SPI Wrapper, all implemented in Verilog and verified using professional EDA tools.

---

## ⚙️ Components

### 1. **SPI Slave**

- Handles serial data communication from the SPI Master.
- Supports standard SPI modes.

### 2. **SP-RAM**

- Single-port RAM used for data storage and retrieval.
- Fully parameterized for data width and depth.
- Accessible via the SPI interface.

### 3. **SPI Wrapper**

- Integrates the SPI Slave and SP-RAM into a single cohesive system.

---

## 🧪 Verification and Simulation

### ✅ **Testbench**

- A self-checking testbench was developed to verify functionality.
- Covered all SPI operations: read, write, and edge cases.
- Waveforms observed and verified using **QuestaSim**.

### 🧰 **Tools Used**

| Tool                  | Purpose                              |
| :-------------------- | :----------------------------------- |
| **QuestaSim**   | RTL Simulation                       |
| **Questa Lint** | Linting & Static Checks              |
| **Vivado**      | Synthesis, Implementation, Bitstream |

### 📈 **FSM Encoding Comparison**

Different FSM encoding styles were explored and analyzed:

- **Binary Encoding**
- **Gray Encoding**
- **One-Hot Encoding**

Simulation and synthesis results were compared for area, timing, and performance impact.

---

## 🔧 FPGA Flow

The complete FPGA design flow was followed step-by-step:

1. **Elaboration**
2. **Synthesis**
3. **Implementation**
4. **Bitstream Generation**
5. **Programming the FPGA Board**

All stages were validated using **Vivado**, and screenshots were captured for documentation purposes.

---

## 🧠 Design Highlights

- Modular, parameterized Verilog design.
- Clean hierarchy and consistent signal naming.
- Verified against multiple FSM encoding schemes.
- Synthesizable and tested on real FPGA hardware.

---

## 🧾 Results Summary

| Stage                | Tool        | Status        |
| -------------------- | ----------- | ------------- |
| Simulation           | QuestaSim   | ✅ Passed     |
| Linting              | Questa Lint | ✅ Clean      |
| Synthesis            | Vivado      | ✅ Successful |
| Implementation       | Vivado      | ✅ Successful |
| Bitstream Generation | Vivado      | ✅ Done       |
| FPGA Testing         | Board Test  | ✅ Verified   |

---

## 👤 Author

**Muhammad Wael**
Digital IC Design Diploma – Final Project

---

## Design Report

[SPI Report](Design/SPI_Report.pdf)
<embed src="Design/SPI_Report.pdf" width="70%" height="400px"/>
