`timescale 1ns/1ps
`default_nettype none

// Convierte Gray[3:0] -> Binario[3:0]
module decoder (
    input  logic ag, bg, cg, dg,   // Gray g3 g2 g1 g0
    output logic ab, bb, cb, db    // Bin  b3 b2 b1 b0
);
    // b3 = g3
    assign ab = ag;
    // b2 = b3 ^ g2
    assign bb = ag ^ bg;
    // b1 = b2 ^ g1
    assign cb = (ag ^ bg) ^ cg;
    // b0 = b1 ^ g0
    assign db = ((ag ^ bg) ^ cg) ^ dg;
endmodule

`default_nettype wire

