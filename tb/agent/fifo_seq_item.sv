`include "uvm_macros.svh"
import uvm_pkg::*;

class fifo_seq_item extends uvm_sequence_item;

    // Randomized stimulus
    rand logic       winc;        // Write Enable
    rand logic       rinc;        // Read Enable
    rand logic [7:0] wdata;       // Data Payload

    // Tracked outputs for the scoreboard
    logic       wfull;
    logic       rempty;
    logic [7:0] rdata;

    `uvm_object_utils_begin(fifo_seq_item)
        `uvm_field_int(winc,  UVM_ALL_ON)
        `uvm_field_int(rinc,  UVM_ALL_ON)
        `uvm_field_int(wdata, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "fifo_seq_item");
        super.new(name);
    endfunction

    // Constraints to ensure realistic traffic weighting (e.g., more active traffic than idle cycles)
    constraint c_traffic_weights {
        winc dist {0:/30, 1:/70}; // 70% chance to write
        rinc dist {0:/30, 1:/70}; // 70% chance to read
    }
endclass
