interface fifo_if #(parameter DSIZE = 8);
    // Write Domain Clocks/Resets
    logic wclk;
    logic wrst_n;

    // Read Domain Clocks/Resets
    logic rclk;
    logic rrst_n;

    // Write Domain Signals
    logic winc;
    logic [DSIZE-1:0] wdata;
    logic wfull;

    // Read Domain Signals
    logic rinc;
    logic [DSIZE-1:0] rdata;
    logic rempty;

    // =========================================================================
    // SystemVerilog Assertions (SVA) for FIFO Safety
    // =========================================================================

    // Ensure we never try to write when the FIFO is asserting the full flag
    property p_no_write_when_full;
        @(posedge wclk) disable iff (!wrst_n)
        wfull |-> !winc;
    endproperty
    assert property (p_no_write_when_full) else $error("CDC Protocol Violation: Write attempted while FIFO is FULL");

    // Ensure we never try to read when the FIFO is asserting the empty flag
    property p_no_read_when_empty;
        @(posedge rclk) disable iff (!rrst_n)
        rempty |-> !rinc;
    endproperty
    assert property (p_no_read_when_empty) else $error("CDC Protocol Violation: Read attempted while FIFO is EMPTY");

endinterface
