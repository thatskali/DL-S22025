`timescale 1ns/1ps
`default_nettype none

// Extrae los 4 datos de la codeword corregida
module hamming_secded_decoder (
    input  logic [7:0] cw,   // {p0,p1,p2,d0,p3,d1,d2,d3}
    output logic [3:0] d
);
    assign d = {cw[7], cw[6], cw[5], cw[3]}; // {d3,d2,d1,d0}
endmodule

`default_nettype wire
