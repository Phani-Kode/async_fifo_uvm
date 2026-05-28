module fifomem #(parameter DSIZE = 8, parameter ASIZE = 4)(
    input  logic             wclk,
    input  logic             wclken,
    input  logic             wfull,
    input  logic [ASIZE-1:0] waddr,
    input  logic [DSIZE-1:0] wdata,
    input  logic [ASIZE-1:0] raddr,
    output logic [DSIZE-1:0] rdata
);
    // Standard dual-port RAM inference
    localparam DEPTH = 1 << ASIZE;
    logic [DSIZE-1:0] mem [0:DEPTH-1];

    // Asynchronous read port
    assign rdata = mem[raddr];

    // Synchronous write port (gated on wclk)
    always_ff @(posedge wclk) begin
        if (wclken && !wfull) begin
            mem[waddr] <= wdata;
        end
    end
endmodule
