`timescale 1ns/1ps
`default_nettype none

// TOP sin reloj: Gray -> Binario -> LEDs y 2x 7 segmentos (cátodo común, activo en '1')
module top (
    // Entradas desde switches en Gray (MSB..LSB)
    input  logic ag, bg, cg, dg,

    // LEDs on-board
    output logic [3:0] led,

    // 7 segmentos (unidades)
    output logic au, bu, cu, du, eu, fu, gu,
    // 7 segmentos (décimas)
    output logic ad, bd, cd, dd, ed, fd, gd
);

    // Gray -> Binario
    logic ab, bb, cb, db;
    decoder u_decoder (
        .ag(ag), .bg(bg), .cg(cg), .dg(dg),
        .ab(ab), .bb(bb), .cb(cb), .db(db)
    );

    // LEDs muestran el valor binario (ab..db)
    logic [3:0] binario;
    assign binario = {ab, bb, cb, db};

    module_leds u_leds (
        .binario(binario),
        .led(led)
    );

    // 7 segmentos combinacional (sin clk): entradas A..D en binario
    module_seg u_seg (
        .A(ab), .B(bb), .C(cb), .D(db),
        .au(au), .bu(bu), .cu(cu), .du(du), .eu(eu), .fu(fu), .gu(gu),
        .ad(ad), .bd(bd), .cd(cd), .dd(dd), .ed(ed), .fd(fd), .gd(gd)
    );

endmodule

`default_nettype wire

