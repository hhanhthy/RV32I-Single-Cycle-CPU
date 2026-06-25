# RV32I Single-Cycle CPU

A Verilog implementation of a **RISC-V RV32I Single-Cycle CPU** — every instruction completes in exactly **one clock cycle**, from fetch to write-back.

> Based on *Patterson & Hennessy — Computer Organization and Design, RISC-V Edition*

---

## ISA Overview

RV32I is the base integer instruction set of the open-source RISC-V architecture. All instructions are **fixed 32-bit wide** with register fields (rs1, rs2, rd) at fixed positions — making the decoder simple and fast.

### Core Instruction Formats

Six encoding formats cover every instruction in the ISA: R, I, S, B, U, and J.

![Core Instruction Formats](images/Core_Instruction_Formats.png)

---

## Instruction Groups

### Arithmetic & Logical

R-type instructions operate on two registers (`rs1 OP rs2`). I-type variants use an immediate (`rs1 OP imm`). The result always goes to `rd`.

![Arithmetic and Logical Instructions](images/Arthmetic_and_Logical.png)

---

### Memory Access

Load (I-type) and Store (S-type) instructions compute the address as `rs1 + imm`.

![Memory Access Instruction Formats](images/Memory.png)

---

### Control Transfer — Branch & Jump

Branch instructions (B-type) compare rs1 and rs2, jumping to `PC + imm` if the condition holds. Jump instructions (J-type / I-type) are unconditional.

![Branch and Jump Instruction Formats](images/Conditional.png)

---

## Datapath Design

### Instruction Fetch

The PC register holds the current instruction address. The Instruction Memory outputs the 32-bit instruction, while an adder simultaneously computes `PC + 4` for the next cycle.

![Instruction Fetch Unit](images/Instruction.png)

---

### Register File & ALU

The **Register File** is the central storage of the datapath — all computations read from and write back to here. Reads are asynchronous; writes are synchronous on the rising clock edge. Register x0 is hard-wired to zero and can never be overwritten.

The **ALU** accepts two 32-bit operands and performs the operation selected by the 4-bit `ALU_operation` signal. It outputs both the 32-bit `result` and a `Zero` flag used by branch instructions.

![Register File and ALU](images/Register_ALU.png)

---

### Data Memory & Immediate Generator

The **Data Memory** unit serves Load and Store instructions. The **Immediate Generator** extracts and sign-extends the immediate value from the instruction's bit fields, adapting to each format (I, S, B, U, J).

![Data Memory and Immediate Generation Unit](images/Data_mem.png)

---

### Complete Single-Cycle Datapath

All blocks connect into one unified datapath. Three data flows operate simultaneously within every clock cycle:

- **Compute** — Registers (rs1, rs2) → ALU → Register rd
- **Memory** — rs1 + Imm → ALU address → Data Memory
- **Branch** — ALU compares rs1 vs rs2 → Zero flag → PCSrc MUX → next PC

![Complete Single-Cycle Datapath](images/Datapath.png)

---

## Control Unit

The Control Unit decodes the 7-bit opcode (`instruction[6:0]`) and drives all datapath signals within the same clock cycle. It uses a **two-level decode** to keep complexity low — a Main Decoder identifies the instruction class, and an ALU Decoder uses funct7 + funct3 to determine the exact ALU operation.

![Complete CPU with Control Unit](images/Control.jpg)

---

*2026 — Hồ Huỳnh Anh Thy*
