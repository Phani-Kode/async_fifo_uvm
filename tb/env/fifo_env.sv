`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)

    fifo_agent      agent;
    fifo_scoreboard scb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = fifo_agent::type_id::create("agent", this);
        scb   = fifo_scoreboard::type_id::create("scb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect the Monitor's Write port to the Scoreboard's Write export
        agent.mon.wr_ap.connect(scb.wr_export);

        // Connect the Monitor's Read port to the Scoreboard's Read export
        agent.mon.rd_ap.connect(scb.rd_export);
    endfunction
endclass
