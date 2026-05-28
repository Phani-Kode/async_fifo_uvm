`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_base_sequence extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_base_sequence)

    function new(string name = "fifo_base_sequence");
        super.new(name);
    endfunction

    task body();
        fifo_seq_item req;

        `uvm_info("SEQ", "Starting Randomized CDC Traffic Sequence", UVM_LOW);

        // Generate 200 randomized read/write transactions to stress test CDC robustness
        repeat(200) begin
            req = fifo_seq_item::type_id::create("req");
            start_item(req);

            if(!req.randomize()) begin
                `uvm_fatal("SEQ", "Randomization failed");
            end

            finish_item(req);
        end

        `uvm_info("SEQ", "Finished Randomized CDC Traffic Sequence", UVM_LOW);
    endtask
endclass
