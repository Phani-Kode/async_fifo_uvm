`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_base_test extends uvm_test;
    `uvm_component_utils(fifo_base_test)

    fifo_env           env;
    fifo_base_sequence seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        seq = fifo_base_sequence::type_id::create("seq");

        // Start the sequence on the agent's sequencer
        seq.start(env.agent.sqr);

        // Wait for final transactions to drain through the synchronizers
        #200;

        phase.drop_objection(this);
    endtask
endclass
