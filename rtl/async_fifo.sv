module async_fifo #(
    parameter DSIZE = 8,  // Data word size
    parameter ASIZE = 4   // Address size (FIFO depth = 2^ASIZE)
)(
    // Write Domain
    input  logic             wclk,
    input  logic             wrst_n,
    input  logic             winc,
    input  logic [DSIZE-1:0] wdata,
    output logic             wfull,

    // Read Domain
    input  logic             rclk,
    input  logic             rrst_n,
    input  logic             rinc,
    output logic [DSIZE-1:0] rdata,
    output logic             rempty
);

    logic [ASIZE-1:0] waddr, raddr;
    logic [ASIZE:0]   wptr, rptr, wq2_rptr, rq2_wptr;

    // Dual-Port RAM Instantiation
    fifomem #(DSIZE, ASIZE) fifomem (
        .wclk  (wclk),
        .wclken(winc),
        .wfull (wfull),
        .waddr (waddr),
        .wdata (wdata),
        .raddr (raddr),
        .rdata (rdata)
    );

    // Synchronize Read Pointer to Write Clock Domain
    sync_r2w #(ASIZE) sync_r2w (
        .wq2_rptr(wq2_rptr),
        .rptr    (rptr),
        .wclk    (wclk),
        .wrst_n  (wrst_n)
    );

    // Synchronize Write Pointer to Read Clock Domain
    sync_w2r #(ASIZE) sync_w2r (
        .rq2_wptr(rq2_wptr),
        .wptr    (wptr),
        .rclk    (rclk),
        .rrst_n  (rrst_n)
    );

    // Write Pointer and Full Flag Logic
    wptr_full #(ASIZE) wptr_full (
        .wfull   (wfull),
        .waddr   (waddr),
        .wptr    (wptr),
        .wq2_rptr(wq2_rptr),
        .winc    (winc),
        .wclk    (wclk),
        .wrst_n  (wrst_n)
    );

    // Read Pointer and Empty Flag Logic
    rptr_empty #(ASIZE) rptr_empty (
        .rempty  (rempty),
        .raddr   (raddr),
        .rptr    (rptr),
        .rq2_wptr(rq2_wptr),
        .rinc    (rinc),
        .rclk    (rclk),
        .rrst_n  (rrst_n)
    );

endmodule
