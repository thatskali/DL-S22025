`timescale 1ns/1ps
`default_nettype none

module top (
    input  logic clk,

    // Switches en Gray (entradas físicas)
    input  logic ag, bg, cg, dg,

    // Switches extra del TB (no indispensables en hardware)
    input  logic sw_rx,
    input  logic sw_mode,

    // LEDs en la placa (mostrar binario)
    output logic [3:0] led,

    // 7 segmentos para "unidades" (a..g, activo en ALTO)
    output logic au, bu, cu, du, eu, fu, gu,
    // 7 segmentos para "décimas" (a..g, activo en ALTO)
    output logic ad, bd, cd, dd, ed, fd, gd
);

    // ---- Gray -> Binario (según PDF) ----
    logic b3, b2, b1, b0;     // ab,bb,cb,db en tu notación anterior
    logic [3:0] binario_sw;   // binario desde los switches
    decoder u_decoder (
        .ag(ag), .bg(bg), .cg(cg), .dg(dg),
        .ab(b3), .bb(b2), .cb(b1), .db(b0)
    );
    assign binario_sw = {b3,b2,b1,b0};

    // ---- Demo Hamming SECDED (8,4) ----
    // Codificamos 4 bits de dato, detectamos/corregimos, y sacamos el dato corregido
    logic [3:0] data_in_demo = 4'hA;     // cámbialo si quieres otra demo
    logic [7:0] codeword;
    logic [2:0] syndrome;
    logic       overall_err;
    logic [7:0] corrected_word;
    logic [3:0] data_out_demo;

    hamming_secded_encoder u_enc (
        .d(data_in_demo),
        .cw(codeword)
    );

    hamming_secded_syndrome u_syn (
        .cw(codeword),
        .syn(syndrome),
        .ov(overall_err)
    );

    hamming_secded_corrector u_cor (
        .cw_in(codeword),
        .syn(syndrome),
        .ov(overall_err),
        .cw_out(corrected_word)
    );

    hamming_secded_decoder u_dec (
        .cw(corrected_word),
        .d(data_out_demo)
    );

    // ---- Selección de fuente a mostrar (sw_mode) ----
    // 0 = switches Gray->binario; 1 = dato corregido por Hamming
    logic [3:0] value_to_show = sw_mode ? data_out_demo : binario_sw;

    // ---- LEDs muestran el binario seleccionado ----
    module_leds u_leds (
        .binario(value_to_show),
        .led(led)
    );

    // ---- 7 segmentos para ambas “pantallas” (dos juegos: u* y d*) ----
    // Mostramos el mismo valor en ambas caras (si prefieres distinto, avísame)
    module_seg u_seg (
        .clk(clk),
        .val(value_to_show),

        // Unidades
        .a_u(au), .b_u(bu), .c_u(cu), .d_u(du), .e_u(eu), .f_u(fu), .g_u(gu),
        // Décimas
        .a_d(ad), .b_d(bd), .c_d(cd), .d_d(dd), .e_d(ed), .f_d(fd), .g_d(gd)
    );

endmodule

`default_nettype wire

