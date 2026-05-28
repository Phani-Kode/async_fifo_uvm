import uvm_pkg::*;
`include "uvm_macros.svh"

module tb_top;
    // 1. Generate Asynchronous Clocks
    logic wclk = 0;
    logic rclk = 0;

    // Write Clock: 10 ns period (100 MHz)
    always #5 wclk = ~wclk;

    // Read Clock: 13 ns period (~77 MHz) — Creating CDC drift
    always #6.5 rclk = ~rclk;

    // 2. Generate Independent Resets
    logic wrst_n = 0;
    logic rrst_n = 0;

    initial begin
        #20 wrst_n = 1; // Deassert write reset
    end

    initial begin
        #25 rrst_n = 1; // Deassert read reset later
    end

    // 3. Instantiate the Interface
    fifo_if #(8) vif (
        .wclk (wclk),
        .wrst_n(wrst_n),
        .rclk (rclk),
        .rrst_n(rrst_n)
    );

    // 4. Instantiate the RTL Design Under Test (DUT)
    async_fifo #(
        .DSIZE(8),
        .ASIZE(4)
    ) dut (
        .wclk  (vif.wclk),
        .wrst_n(vif.wrst_n),
        .winc  (vif.winc),
        .wdata (vif.wdata),
        .wfull (vif.wfull),
        .rclk  (vif.rclk),
        .rrst_n(vif.rrst_n),
        .rinc  (vif.rinc),
        .rdata (vif.rdata),
        .rempty(vif.rempty)
    );

    // 5. Pass Virtual Interface to UVM and Run Test
    initial begin
        uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", vif);
        run_test("fifo_base_test");
    end

    // Optional: Dump waveforms
    initial begin
        $dumpfile("async_fifo.vcd");
        $dumpvars(0, tb_top);
    end
endmodule
