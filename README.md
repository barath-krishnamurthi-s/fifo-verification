# FIFO Functional Verification using Verilog

## 📌 Overview

This project implements and verifies the functional behavior of a **First-In First-Out (FIFO) memory** using **Verilog HDL**.

A dedicated testbench is used to verify the FIFO's:

- Write operation
- Read operation
- Synchronous reset
- `full` flag
- `empty` flag
- Data integrity
- Read latency

The testbench uses a **reference memory model** to compare the expected FIFO output against the actual DUT output.

---

## 🏗️ Design Configuration

| Parameter | Value |
|---|---:|
| Data Width | 8 bits |
| FIFO Depth | 16 entries |
| Clock Period | 10 ns |
| Reset | Synchronous, Active High |
| Read Enable | `rd_en` |
| Write Enable | `wr_en` |
| Data Input | `din[7:0]` |
| Data Output | `dout[7:0]` |

---

## 🔌 FIFO Interface

| Signal | Direction | Description |
|---|---|---|
| `clk` | Input | System clock |
| `srst` | Input | Synchronous reset |
| `din[7:0]` | Input | 8-bit input data |
| `wr_en` | Input | Write enable |
| `rd_en` | Input | Read enable |
| `dout[7:0]` | Output | 8-bit output data |
| `full` | Output | Indicates FIFO is full |
| `empty` | Output | Indicates FIFO is empty |

---

## 🧪 Verification Methodology

The testbench contains a simple **reference model**:

```verilog
reg [7:0] exp_mem [0:15];
integer wptr;
integer rptr;
```

Whenever data is written into the FIFO, the same data is stored in the reference memory.

During a read operation, the testbench compares the FIFO output with the corresponding expected value:

```verilog
if (dout !== exp_mem[rptr])
    $fatal("DATA MISMATCH: exp=%0h got=%0h",
           exp_mem[rptr], dout);
```

This allows the testbench to automatically detect incorrect FIFO behavior.

---

## 🔄 Verification Flow

```text
              ┌───────────────┐
              │     Reset     │
              │   FIFO = 0    │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │ Reset Checks  │
              │ Empty = 1     │
              │ Full  = 0     │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │  Write Phase  │
              │ Write 4 Bytes │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │   Read Phase  │
              │ Read 4 Bytes  │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │ Compare DUT   │
              │ with Expected │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │ Final Empty   │
              │     Check     │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │     PASS      │
              └───────────────┘
```

---

## ⏱️ Test Sequence

### 1. Reset

The FIFO is held in reset for five clock cycles.

After reset is released, the testbench verifies:

```text
empty = 1
full  = 0
```

Expected output:

```text
RESET CHECK PASSED
```

### 2. Write Operation

Four data values are written into the FIFO.

The testbench also stores the expected values:

```text
1
2
3
4
```

The `full` flag is checked before every write to ensure that the FIFO does not become full prematurely.

### 3. Read Operation

The four previously written values are read from the FIFO.

Each output is compared against the reference model:

```text
Expected → Actual
1        → 1
2        → 2
3        → 3
4        → 4
```

### 4. Final Empty Check

After all four values are read, the testbench verifies:

```verilog
if (empty !== 1'b1)
    $fatal("FIFO NOT EMPTY AFTER READS");
```

---

## 📂 Suggested Repository Structure

```text
fifo-verilog-verification/
│
├── rtl/
│   └── fifo_generator_0.v
│
├── tb/
│   └── tb_fifo.v
│
├── sim/
│   └── simulation_files/
│
├── docs/
│   └── waveform.png
│
├── README.md
└── LICENSE
```

> If `fifo_generator_0` is generated using Xilinx Vivado IP, keep the generated IP sources/configuration in the repository as appropriate for your project setup.

---

## 🛠️ Tools Used

- **Verilog HDL**
- **Xilinx Vivado**
- **FIFO Generator IP**
- **Simulation / Waveform Viewer**

---

## ▶️ Running the Simulation

### Using Vivado

1. Open **Xilinx Vivado**.
2. Create or open the FPGA project.
3. Add the FIFO IP:
   ```text
   FIFO Generator
   ```
4. Add the FIFO RTL/IP output files.
5. Add the testbench:
   ```text
   tb_fifo.v
   ```
6. Set `tb_fifo` as the simulation top module.
7. Run:
   ```text
   Run Simulation → Run Behavioral Simulation
   ```
8. Observe the waveform and console output.

---

## ✅ Expected Result

A successful simulation should display:

```text
RESET CHECK PASSED
====================================
 FIFO BASIC FUNCTIONAL VERIFICATION PASSED
====================================
```

If an error occurs, `$fatal` terminates the simulation and reports the failure.

For example:

```text
FIFO FULL TOO EARLY
```

or:

```text
DATA MISMATCH: exp=01 got=xx
```

---

## 📊 Verification Checks

| Test | Status |
|---|---|
| Synchronous Reset | ✅ |
| Initial Empty Flag | ✅ |
| Initial Full Flag | ✅ |
| Write Operation | ✅ |
| Read Operation | ✅ |
| Data Integrity | ✅ |
| Read Latency | ✅ |
| Final Empty Flag | ✅ |

---

## 🎯 Project Objective

The objective of this project is to demonstrate a basic **RTL verification methodology for FIFO memory**, using a reference model and automated assertions/checks to validate the behavior of the DUT.

This project provides practical experience with:

- Verilog testbench development
- Synchronous digital design
- FIFO operation
- Reference-model-based verification
- Clock-driven simulation
- Automated error detection
- FPGA IP simulation

---

## 🚀 Future Improvements

The verification environment can be extended with:

- Randomized read/write transactions
- Simultaneous read and write testing
- FIFO full-condition testing
- FIFO overflow testing
- FIFO underflow testing
- Reset during active transactions
- Constrained-random verification
- SystemVerilog assertions
- Functional coverage
- Scoreboard-based verification
- Automated regression testing

---

## 👨‍💻 Author

**.**

Electronics and Communication Engineering  
Interested in **VLSI, Embedded Systems, Digital Design and Verification**

---
