`include "uvm_macros.svh"
import uvm_pkg::*;

// Define custom macros to allow two different write() functions in one scoreboard
`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    // Two exports to receive data from the write clock and read clock domains
    uvm_analysis_imp_wr #(fifo_seq_item, fifo_scoreboard) wr_export;
    uvm_analysis_imp_rd #(fifo_seq_item, fifo_scoreboard) rd_export;

    // Golden Reference Model: An unbounded queue to simulate the FIFO memory
    logic [7:0] expected_queue [$];

    function new(string name, uvm_component parent);
        super.new(name, parent);
        wr_export = new("wr_export", this);
        rd_export = new("rd_export", this);
    endfunction

    // This function triggers automatically when the monitor captures a Write transaction
    virtual function void write_wr(fifo_seq_item item);
        // Push the written data into our reference queue
        expected_queue.push_back(item.wdata);
        `uvm_info("SCB_WR", $sformatf("Stored Data %0h in reference model", item.wdata), UVM_HIGH);
    endfunction

    // This function triggers automatically when the monitor captures a Read transaction
    virtual function void write_rd(fifo_seq_item item);
        logic [7:0] expected_data;

        if (expected_queue.size() == 0) begin
            `uvm_error("SCB_FAIL", "Read occurred on the bus, but reference model is empty! (Underflow issue)");
        end else begin
            // Pop the oldest data from our queue and compare it to the actual read data
            expected_data = expected_queue.pop_front();

            if (expected_data !== item.rdata) begin
                `uvm_error("SCB_FAIL", $sformatf("Data Mismatch across CDC! Expected: %0h, Actual: %0h", expected_data, item.rdata));
            end else begin
                `uvm_info("SCB_PASS", $sformatf("Data Match: %0h crossed clock domains successfully", item.rdata), UVM_HIGH);
            end
        end
    endfunction
endclass
