`default_nettype none

module my_chip (
    input logic [11:0] io_in, // Inputs to your chip
    output logic [11:0] io_out, // Outputs from your chip
    input logic clock,
    input logic reset // Important: Reset is ACTIVE-HIGH
);
    
// Instantiate the RangeFinder module
    logic [15:0] data_in;
    logic [15:0] range;
    logic debug_error;
    logic go, finish;

    assign data_in = {4'b0000, io_in[7:0]};  // Example: Map io_in[7:0] as input data
    assign go = io_in[8];  // Example: Use io_in[8] as 'go' signal
    assign finish = io_in[9];  // Example: Use io_in[9] as 'finish' signal

    RangeFinder #(.WIDTH(16)) rf_inst (
        .clock(clock),
        .reset(reset),
        .go(go),
        .finish(finish),
        .data_in(data_in),
        .range(range),
        .debug_error(debug_error)
    );

    assign io_out[7:0] = range[7:0];  // Example: Map lower 8 bits of range to output
    assign io_out[8] = debug_error;   // Example: Map debug_error to io_out[8]
    assign io_out[11:9] = 3'b000;     // Unused bits set to 0

endmodule
