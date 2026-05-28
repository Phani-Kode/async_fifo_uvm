module sync_r2w #(parameter ASIZE = 4)(
    output logic [ASIZE:0] wq2_rptr,
    input  logic [ASIZE:0] rptr,
    input  logic           wclk,
    input  logic           wrst_n
);
    logic [ASIZE:0] wq1_rptr;

    always_ff @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n) begin
            wq1_rptr <= 0;
            wq2_rptr <= 0;
        end else begin
            // 2-stage synchronization
            wq1_rptr <= rptr;
            wq2_rptr <= wq1_rptr;
        end
    end
endmodule
