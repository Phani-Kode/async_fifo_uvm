`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_driver extends uvm_driver #(fifo_seq_item);
    `uvm_component_utils(fifo_driver)

    virtual fifo_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
        end
    endfunction

    task run_phase(uvm_phase phase);
        // Wait for resets to clear in both asynchronous domains
        fork
            @(posedge vif.wclk iff vif.wrst_n == 1'b1);
            @(posedge vif.rclk iff vif.rrst_n == 1'b1);
        join

        // Initialize driver signals
        vif.winc  <= 0;
        vif.wdata <= 0;
        vif.rinc  <= 0;

        forever begin
            seq_item_port.get_next_item(req);

            // Fork concurrent blocks to drive asynchronous domains independently
            fork
                begin
                    // --- Write Domain ---
                    @(posedge vif.wclk);
                    // Only drive write signals if the FIFO is not full
                    if (!vif.wfull) begin
                        vif.winc  <= req.winc;
                        vif.wdata <= req.wdata;
                    end else begin
                        vif.winc  <= 0;
                    end
                end
                begin
                    // --- Read Domain ---
                    @(posedge vif.rclk);
                    // Only drive read signals if the FIFO is not empty
                    if (!vif.rempty) begin
                        vif.rinc <= req.rinc;
                    end else begin
                        vif.rinc <= 0;
                    end
                end
            join

            seq_item_port.item_done();
        end
    endtask
endclass
