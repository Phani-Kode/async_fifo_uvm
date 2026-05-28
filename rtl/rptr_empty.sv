module rptr_empty #(parameter ASIZE = 4)(
    output logic             rempty,
    output logic [ASIZE-1:0] raddr,
    output logic [ASIZE:0]   rptr,
    input  logic [ASIZE:0]   rq2_wptr, // Synchronized write pointer
    input  logic             rinc,
    input  logic             rclk,
    input  logic             rrst_n
);
    logic [ASIZE:0] rbin;
    logic [ASIZE:0] rbnext, rgraynext;
    logic rempty_val;

    // Memory read-address pointer (binary)
    assign raddr = rbin[ASIZE-1:0];

    always_ff @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rbin   <= 0;
            rptr   <= 0;
            rempty <= 1; // FIFO starts empty
        end else begin
            rbin   <= rbnext;
            rptr   <= rgraynext;
            rempty <= rempty_val;
        end
    end

    // Increment binary pointer if not empty and read is requested
    assign rbnext = rbin + (rinc & ~rempty);

    // Binary-to-Gray conversion
    assign rgraynext = (rbnext >> 1) ^ rbnext;

    // FIFO empty condition:
    // The read pointer has caught up to the synchronized write pointer exactly.
    assign rempty_val = (rgraynext == rq2_wptr);

endmodule
