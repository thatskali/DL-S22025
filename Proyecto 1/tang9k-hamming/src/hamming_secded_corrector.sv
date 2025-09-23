`timescale 1ns/1ps
`default_nettype none

// Corrige 1-bit error en SECDED (8,4). Si syn!=0 y ov=1 => voltea el bit indicado.
// Si syn==0 y ov=1 => error de 2 bits (no corregible con SECDED).
module hamming_secded_corrector (
    input  logic [7:0] cw_in,     // {p0,p1,p2,d0,p3,d1,d2,d3}
    input  logic [2:0] syn,       // {s3,s2,s1}
    input  logic       ov,
    output logic [7:0] cw_out
);
    logic [7:0] tmp;
    always_comb begin
        tmp = cw_in;
        if (ov && (syn != 3'b000)) begin
            // posiciones 1..7 (no tocamos p0 con syn)
            case (syn)
                3'd1: tmp[2] = ~tmp[2]; // p1 (pos1)
                3'd2: tmp[1] = ~tmp[1]; // p2 (pos2)
                3'd3: tmp[3] = ~tmp[3]; // d0 (pos3)
                3'd4: tmp[4] = ~tmp[4]; // p3 (pos4)
                3'd5: tmp[5] = ~tmp[5]; // d1 (pos5)
                3'd6: tmp[6] = ~tmp[6]; // d2 (pos6)
                3'd7: tmp[7] = ~tmp[7]; // d3 (pos7)
                default: ; // no-op
            endcase
        end
        // Si syn==0 y ov==1 -> error doble: no conocemos cuál corregir, dejamos igual
        cw_out = tmp;
    end
endmodule

`default_nettype wire
