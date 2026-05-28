`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_monitor extends uvm_monitor;
    `uvm_component_utils(fifo_monitor)

    virtual fifo_if vif;

    // Two analysis ports to separate asynchronous read and write traffic
    uvm_analysis_port #(fifo_seq_item) wr_ap;
    uvm_analysis_port #(fifo_seq_item) rd_ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        wr_ap = new("wr_ap", this);
        rd_ap = new("rd_ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
        end
    endfunction

    task run_phase(uvm_phase phase);
        // Run both monitoring tasks continuously in parallel
        fork
            monitor_write_domain();
            monitor_read_domain();
        join
    endtask

    // Passively track writes synchronized to wclk
    task monitor_write_domain();
        fifo_seq_item item;
        forever begin
            @(posedge vif.wclk);
            if (vif.winc && !vif.wfull) begin
                item = fifo_seq_item::type_id::create("item");
                item.winc  = 1;
                item.wdata = vif.wdata;
                wr_ap.write(item); // Broadcast to the write analysis port
            end
        end
    endtask

    // Passively track reads synchronized to rclk
    task monitor_read_domain();
        fifo_seq_item item;
        forever begin
            @(posedge vif.rclk);
            if (vif.rinc && !vif.rempty) begin
                item = fifo_seq_item::type_id::create("item");
                item.rinc  = 1;
                item.rdata = vif.rdata; // Capture the actual data read
                rd_ap.write(item); // Broadcast to the read analysis port
            end
        end
    endtask
endclass
