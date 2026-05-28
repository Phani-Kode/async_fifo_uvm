module wptr_full #(parameter ASIZE = 4)(
    output logic             wfull,
    output logic [ASIZE-1:0] waddr,
    output logic [ASIZE:0]   wptr,
    input  logic [ASIZE:0]   wq2_rptr, // Synchronized read pointer
    input  logic             winc,
    input  logic             wclk,
    input  logic             wrst_n
);
    logic [ASIZE:0] wbin;
    logic [ASIZE:0] wbnext, wgraynext;
    logic wfull_val;

    // Memory write-address pointer (binary)
    assign waddr = wbin[ASIZE-1:0];

    always_ff @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wbin  <= 0;
            wptr  <= 0;
            wfull <= 0;
        end else begin
            wbin  <= wbnext;
            wptr  <= wgraynext;
            wfull <= wfull_val;
        end
    end

    // Increment binary pointer if not full and write is requested
    assign wbnext = wbin + (winc & ~wfull);

    // Binary-to-Gray conversion
    assign wgraynext = (wbnext >> 1) ^ wbnext;

    // FIFO full condition:
    // The write pointer has caught up to the read pointer but is exactly one wrap-around ahead.
    // In Gray code, this means the MSB and 2nd MSB are inverted, and the rest match.
    assign wfull_val = (wgraynext == {~wq2_rptr[ASIZE:ASIZE-1], wq2_rptr[ASIZE-2:0]});

endmodule
