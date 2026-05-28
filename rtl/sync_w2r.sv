module sync_w2r #(parameter ASIZE = 4)(
    output logic [ASIZE:0] rq2_wptr,
    input  logic [ASIZE:0] wptr,
    input  logic           rclk,
    input  logic           rrst_n
);
    logic [ASIZE:0] rq1_wptr;

    always_ff @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n) begin
            rq1_wptr <= 0;
            rq2_wptr <= 0;
        end else begin
            // 2-stage synchronization
            rq1_wptr <= wptr;
            rq2_wptr <= rq1_wptr;
        end
    end
endmodule
