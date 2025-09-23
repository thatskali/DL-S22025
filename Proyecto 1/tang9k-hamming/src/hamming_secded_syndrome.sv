`timescale 1ns/1ps
`default_nettype none

// Calcula síndrome (p1,p2,p3) y error global ov para SECDED (8,4)
module hamming_secded_syndrome (
    input  logic [7:0] cw,       // {p0,p1,p2,d0,p3,d1,d2,d3}
    output logic [2:0] syn,      // {s3,s2,s1} -> posición (1..7) si error de 1 bit
    output logic       ov        // paridad global (1 si #1s impar -> error global)
);
    // Recalcular paridades
    logic s1, s2, s3; // corresponden a p1, p2, p3
    // p1 cubre (1,3,5,7): p1 ^ d0 ^ d1 ^ d3
    assign s1 = cw[2] ^ cw[3] ^ cw[5] ^ cw[7];
    // p2 cubre (2,3,6,7): p2 ^ d0 ^ d2 ^ d3
    assign s2 = cw[1] ^ cw[3] ^ cw[6] ^ cw[7];
    // p3 cubre (4,5,6,7): p3 ^ d1 ^ d2 ^ d3
    assign s3 = cw[4] ^ cw[5] ^ cw[6] ^ cw[7];

    assign syn = {s3,s2,s1};

    // Paridad global (p0 ^ todos los demás)
    assign ov = cw[7] ^ cw[6] ^ cw[5] ^ cw[4] ^ cw[3] ^ cw[2] ^ cw[1] ^ cw[0];
endmodule

`default_nettype wire
