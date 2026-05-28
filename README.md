# UVM Verification of Asynchronous FIFO

## Overview
This repository contains the RTL design and a comprehensive Universal Verification Methodology (UVM) testbench for a parameterized Asynchronous FIFO. The hardware utilizes Gray-code pointers and multi-stage synchronizers to safely pass data between two independent, asynchronous clock domains.

The verification environment focuses heavily on verifying **Clock Domain Crossing (CDC) robustness under randomized traffic conditions**.

## Key Features
* **RTL Architecture:** Dual-clock Asynchronous FIFO with Gray-code pointer synchronization.
* **UVM Testbench:** Fully reusable UVM environment including Agents, Scoreboards, and Coverage models.
* **CDC Verification:** Randomized clock frequencies, phase shifts, and burst traffic sequences designed to stress-test full, empty, almost_full, and almost_empty flags.
* **Verification Checks:** Self-checking scoreboard ensuring zero data corruption, loss, or duplication across clock domains.
* **Tools Used:** SystemVerilog, UVM, QuestaSim / Synopsys VCS, Makefiles, Linux.

## Directory Structure
```
async_fifo_uvm/
├── docs/               # CDC architecture diagrams and verification plan
├── rtl/                # SystemVerilog Design Files
│   ├── async_fifo.sv   # Top-level FIFO
│   ├── rptr_empty.sv   # Read pointer and empty logic
│   ├── wptr_full.sv    # Write pointer and full logic
│   ├── sync_r2w.sv     # Synchronizer: Read to Write domain
│   ├── sync_w2r.sv     # Synchronizer: Write to Read domain
│   └── fifomem.sv      # Dual-port RAM
├── tb/                 # UVM Testbench Environment
│   ├── env/            # Environment, Scoreboard
│   ├── agent/          # Sequencer, Driver, Monitor
│   ├── sequences/      # Randomized traffic generators
│   ├── tests/          # UVM test library
│   └── tb_top.sv       # Top-level simulation module
├── scripts/            # Makefiles for QuestaSim/VCS
└── README.md
```
