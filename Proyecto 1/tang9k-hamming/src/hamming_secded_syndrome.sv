`default_nettype none
module hamming_secded_syndrome (
    input  logic [7:0] r,          // recibido (7:0)
    output logic [2:0] syn,        // {s4,s2,s1} -> 0..7 (1..7 señalan bit con error)
    output logic       overall_err // 1 si paridad total impar (error impar de bits)
);
    logic s1, s2, s4;
    assign s1 = r[0] ^ r[2] ^ r[4] ^ r[6]; // p1 ^ d0 ^ d1 ^ d3
    assign s2 = r[1] ^ r[2] ^ r[5] ^ r[6]; // p2 ^ d0 ^ d2 ^ d3
    assign s4 = r[3] ^ r[4] ^ r[5] ^ r[6]; // p4 ^ d1 ^ d2 ^ d3
    assign syn = {s4, s2, s1};

    // Paridad global: 0 si todo bien (paridad par), 1 si error impar de bits
    assign overall_err = ^r; // XOR de los 8 bits
endmodule

