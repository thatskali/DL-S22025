`timescale 1ns/1ps
`default_nettype none

// Decodifica A..D (binario) a 7 segmentos para dos displays (U y D)
// Common-cathode => '1' enciende el segmento
module module_seg (
    input  logic A, B, C, D,   // binario: A=MSB, D=LSB (A B C D)
    // Unidades
    output logic au, bu, cu, du, eu, fu, gu,
    // Décimas
    output logic ad, bd, cd, dd, ed, fd, gd
);
    logic [3:0] val;
    logic [6:0] seg; // {a,b,c,d,e,f,g}

    assign val = {A,B,C,D};

    // Tabla para 0..9 (1 enciende el segmento). Para otros valores, apaga todo.
    always_comb begin
        case (val)
            4'd0: seg = 7'b1111110; // 0
            4'd1: seg = 7'b0110000; // 1
            4'd2: seg = 7'b1101101; // 2
            4'd3: seg = 7'b1111001; // 3
            4'd4: seg = 7'b0110011; // 4
            4'd5: seg = 7'b1011011; // 5
            4'd6: seg = 7'b1011111; // 6
            4'd7: seg = 7'b1110000; // 7
            4'd8: seg = 7'b1111111; // 8
            4'd9: seg = 7'b1111011; // 9
            default: seg = 7'b0000000; // apaga todo
        endcase
    end

    // Copiamos el mismo dígito a U y a D (sin multiplexar)
    assign {au,bu,cu,du,eu,fu,gu} = seg;
    assign {ad,bd,cd,dd,ed,fd,gd} = seg;
endmodule

`default_nettype wire

