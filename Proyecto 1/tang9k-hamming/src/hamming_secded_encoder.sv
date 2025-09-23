`timescale 1ns/1ps
`default_nettype none

// Hamming SECDED (8,4): palabra de 8 bits = [p0 p1 p2 d0 p3 d1 d2 d3]
// p0: paridad global (XOR de todos los demás bits)
// p1 cubre posiciones con bit0=1 (1,3,5,7)
// p2 cubre posiciones con bit1=1 (2,3,6,7)
// p3 cubre posiciones con bit2=1 (4,5,6,7)
module hamming_secded_encoder (
    input  logic [3:0] d,   // d3..d0
    output logic [7:0] cw   // codeword
);
    logic p1, p2, p3, p0;
    // Ubicaciones: [7:0] = {p0, p1, p2, d0, p3, d1, d2, d3}
    // Para paridades, usamos d0=d[0], d1=d[1], d2=d[2], d3=d[3]
    assign p1 = d[0] ^ d[1] ^ d[3];            // posiciones 1,3,5,7
    assign p2 = d[0] ^ d[2] ^ d[3];            // posiciones 2,3,6,7
    assign p3 = d[1] ^ d[2] ^ d[3];            // posiciones 4,5,6,7

    assign cw[3] = d[0];
    assign cw[1] = p2;
    assign cw[2] = p1;
    assign cw[5] = d[1];
    assign cw[6] = d[2];
    assign cw[7] = d[3];
    assign cw[4] = p3;

    assign p0 = cw[7] ^ cw[6] ^ cw[5] ^ cw[4] ^ cw[3] ^ cw[2] ^ cw[1]; // paridad global
    assign cw[0] = p0;
endmodule

`default_nettype wire
