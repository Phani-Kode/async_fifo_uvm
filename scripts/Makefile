# Makefile for Asynchronous FIFO UVM Verification
# Target EDA Tool: QuestaSim / ModelSim

RTL_DIR  = ../rtl
TB_DIR   = ../tb
WORK_DIR = work

# SystemVerilog Interface
IF_FILE = $(TB_DIR)/env/fifo_if.sv

# RTL Files (bottom-up compilation order)
RTL_FILES = $(RTL_DIR)/fifomem.sv \
            $(RTL_DIR)/sync_r2w.sv \
            $(RTL_DIR)/sync_w2r.sv \
            $(RTL_DIR)/wptr_full.sv \
            $(RTL_DIR)/rptr_empty.sv \
            $(RTL_DIR)/async_fifo.sv

# UVM Testbench Files
TB_FILES  = $(TB_DIR)/agent/fifo_seq_item.sv \
            $(TB_DIR)/agent/fifo_monitor.sv \
            $(TB_DIR)/agent/fifo_driver.sv \
            $(TB_DIR)/agent/fifo_agent.sv \
            $(TB_DIR)/env/fifo_scoreboard.sv \
            $(TB_DIR)/env/fifo_env.sv \
            $(TB_DIR)/sequences/fifo_sequence.sv \
            $(TB_DIR)/tests/fifo_test.sv \
            $(TB_DIR)/tb_top.sv

UVM_FLAGS = -L mtiUvm -uvmcontrol=all

.PHONY: all clean compile simulate

all: clean compile simulate

compile:
	@echo "--- Compiling RTL and UVM Testbench ---"
	vlib $(WORK_DIR)
	vmap work $(WORK_DIR)
	vlog -work $(WORK_DIR) +acc $(UVM_FLAGS) $(IF_FILE) $(RTL_FILES) $(TB_FILES)

simulate:
	@echo "--- Running UVM Simulation ---"
	vsim -c -do "run -all; exit" $(WORK_DIR).tb_top +UVM_TESTNAME=fifo_base_test

clean:
	@echo "--- Cleaning up ---"
	rm -rf $(WORK_DIR) transcript vsim.wlf *.vcd
