`timescale 1ns/1ps
`default_nettype none

module top (
    input  logic clk,

    // Switches físicos en Gray (entradas async)
    input  logic ag, bg, cg, dg,

    // LEDs en la placa
    output logic [3:0] led,

    // 7 segmentos (común cátodo, activo en ALTO)
    output logic au, bu, cu, du, eu, fu, gu,
    output logic ad, bd, cd, dd, ed, fd, gd
);

    // ----------------------------------------------------------------
    // Sincronizadores de 2 etapas para los switches (a clk)
    // ----------------------------------------------------------------
    logic ag_ff1, ag_sync;
    logic bg_ff1, bg_sync;
    logic cg_ff1, cg_sync;
    logic dg_ff1, dg_sync;

    always_ff @(posedge clk) begin
        ag_ff1 <= ag;  ag_sync <= ag_ff1;
        bg_ff1 <= bg;  bg_sync <= bg_ff1;
        cg_ff1 <= cg;  cg_sync <= cg_ff1;
        dg_ff1 <= dg;  dg_sync <= dg_ff1;
    end

    // ----------------------------------------------------------------
    // Gray -> Binario
    // ----------------------------------------------------------------
    logic ab, bb, cb, db;      // bits binarios individuales
    logic [3:0] binario;       // vector binario

    decoder u_decoder (
        .ag(ag_sync), .bg(bg_sync), .cg(cg_sync), .dg(dg_sync),
        .ab(ab),      .bb(bb),      .cb(cb),      .db(db)
    );

    assign binario = {ab, bb, cb, db};

    // ----------------------------------------------------------------
    // LEDs muestran el binario
    // ----------------------------------------------------------------
    module_leds u_module_leds (
        .binario(binario),
        .led(led)
    );

    // ----------------------------------------------------------------
    // 7 segmentos (unidades y décimas) - cátodo común, activo en ALTO
    // ----------------------------------------------------------------
    module_seg u_module_seg (
        .clk(clk),
        .A(ab), .B(bb), .C(cb), .D(db),
        .au(au), .bu(bu), .cu(cu), .du(du), .eu(eu), .fu(fu), .gu(gu),
        .ad(ad), .bd(bd), .cd(cd), .dd(dd), .ed(ed), .fd(fd), .gd(gd)
    );

endmodule

`default_nettype wire
