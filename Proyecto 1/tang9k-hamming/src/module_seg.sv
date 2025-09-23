`timescale 1ns/1ps
`default_nettype none

// Dos displays de 7 segmentos "separados": juego U (unidades) y juego D (décimas).
// Cada juego tiene sus 7 líneas a..g (activo en ALTO).
// Mostramos el mismo nibble 'val' en ambos (puedo hacerlo diferente si lo prefieres).
module module_seg (
    input  logic       clk,
    input  logic [3:0] val,

    // Unidades
    output logic a_u, b_u, c_u, d_u, e_u, f_u, g_u,
    // Décimas
    output logic a_d, b_d, c_d, d_d, e_d, f_d, g_d
);

    // Codificador HEX -> 7 segmentos (activo en ALTO, common cathode)
    function automatic [6:0] hex7 (input logic [3:0] x);
        // {a,b,c,d,e,f,g}
        case (x)
            4'h0: hex7 = 7'b1111110;
            4'h1: hex7 = 7'b0110000;
            4'h2: hex7 = 7'b1101101;
            4'h3: hex7 = 7'b1111001;
            4'h4: hex7 = 7'b0110011;
            4'h5: hex7 = 7'b1011011;
            4'h6: hex7 = 7'b1011111;
            4'h7: hex7 = 7'b1110000;
            4'h8: hex7 = 7'b1111111;
            4'h9: hex7 = 7'b1111011;
            4'hA: hex7 = 7'b1110111;
            4'hB: hex7 = 7'b0011111; // b minúscula (para HEX)
            4'hC: hex7 = 7'b1001110;
            4'hD: hex7 = 7'b0111101; // d minúscula
            4'hE: hex7 = 7'b1001111;
            4'hF: hex7 = 7'b1000111;
        endcase
    endfunction

    logic [6:0] seg_u, seg_d;

    // Mismo valor en ambos juegos
    always_comb begin
        seg_u = hex7(val);
        seg_d = hex7(val);
    end

    // Asignación a pines
    assign {a_u, b_u, c_u, d_u, e_u, f_u, g_u} = seg_u;
    assign {a_d, b_d, c_d, d_d, e_d, f_d, g_d} = seg_d;

endmodule

`default_nettype wire
