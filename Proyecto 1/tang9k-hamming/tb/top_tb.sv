`timescale 1ns/1ps
`default_nettype none

module top_tb;

  // Entradas al DUT
  logic ag, bg, cg, dg;

  // Salidas del DUT
  wire [3:0] led;
  wire au, bu, cu, du, eu, fu, gu;   // unidades (7-seg cátodo común, activo en 1)
  wire ad, bd, cd, dd, ed, fd, gd;   // décimas  (7-seg cátodo común, activo en 1)

  // Si tu top tiene clk, descomenta estas dos líneas y conéctalo abajo.
  // logic clk;
  // always #5 clk = ~clk;

  // Instancia del diseño
  top dut (
    // .clk(clk),  // <-- descomenta si tu top tiene reloj
    .ag(ag), .bg(bg), .cg(cg), .dg(dg),
    .led(led),
    .au(au), .bu(bu), .cu(cu), .du(du), .eu(eu), .fu(fu), .gu(gu),
    .ad(ad), .bd(bd), .cd(cd), .dd(dd), .ed(ed), .fd(fd), .gd(gd)
  );

  // Función: binario -> Gray (n ^ (n>>1))
  function automatic [3:0] bin_to_gray(input [3:0] n);
    return n ^ (n >> 1);
  endfunction

  // Pretty print de los 7 segmentos como "abcdefg"
  function automatic [55*8-1:0] seg_to_str(input [6:0] s);
    seg_to_str = {
      (s[6] ? "g" : "-"), // g
      (s[5] ? "f" : "-"), // f
      (s[4] ? "e" : "-"), // e
      (s[3] ? "d" : "-"), // d
      (s[2] ? "c" : "-"), // c
      (s[1] ? "b" : "-"), // b
      (s[0] ? "a" : "-")  // a
    };
  endfunction

  // Estímulos
  integer i;
  logic [3:0] g;
  logic [6:0] segU, segD;

  initial begin
    // Inicialización para evitar X/Z en sim
    ag = 0; bg = 0; cg = 0; dg = 0;
    // clk = 0; // si usas reloj

    $display(" time(ns) | gray agbgcgdg | led |   U[a..g]   |   D[a..g]");
    $display("-----------------------------------------------------------");

    // Recorremos 0..9 en binario, convertimos a Gray y aplicamos
    for (i = 0; i <= 9; i++) begin
      g = bin_to_gray(i[3:0]);       // g[3]=MSB ... g[0]=LSB
      // Mapeo a pines físicos: ag es el MSB
      ag = g[3]; bg = g[2]; cg = g[1]; dg = g[0];

      // Espera combinacional pequeña para propagar
      #1;

      // Captura de 7-seg (unidades y décimas) en orden a..g
      segU = {gu, fu, eu, du, cu, bu, au};
      segD = {gd, fd, ed, dd, cd, bd, ad};

      $display("%8t | gray=%b | led=%b | U=%07b | D=%07b",
         $time, {ag,bg,cg,dg}, led,
         {au,bu,cu,du,eu,fu,gu}, {ad,bd,cd,dd,ed,fd,gd});


      #49; // total 50 ns por dígito
    end

    $finish;
  end

endmodule

`default_nettype wire
