`timescale 1ns/1ps
`default_nettype none

module top_tb;

  // clock
  logic clk;

  // switches Gray (entradas a DUT)
  logic ag, bg, cg, dg;

  // controles de demo
  logic sw_rx;     // no usado internamente (reservado), mantenlo en 0
  logic sw_mode;   // 0: muestra switches; 1: muestra dato corregido Hamming

  // salidas
  logic [3:0] led;

  // 7 segmentos (unidades)
  logic au, bu, cu, du, eu, fu, gu;
  // 7 segmentos (décimas)
  logic ad, bd, cd, dd, ed, fd, gd;

  // ========= DUT =========
  top dut (
      .clk(clk),
      .ag(ag), .bg(bg), .cg(cg), .dg(dg),
      .sw_rx(sw_rx),
      .sw_mode(sw_mode),
      .led(led),
      .au(au), .bu(bu), .cu(cu), .du(du), .eu(eu), .fu(fu), .gu(gu),
      .ad(ad), .bd(bd), .cd(cd), .dd(dd), .ed(ed), .fd(fd), .gd(gd)
  );

  // reloj 100 MHz simulado (10 ns periodo)
  initial clk = 0;
  always #5 clk = ~clk;

  // estímulos
  initial begin
    sw_rx   = 1'b0;
    sw_mode = 1'b0; // ver switches al inicio

    // switches Gray en 0000
    ag=0; bg=0; cg=0; dg=0;  #20;

    // barrido Gray (ejemplos)
    ag=1; bg=0; cg=0; dg=0;  #20;
    ag=0; bg=1; cg=0; dg=0;  #20;
    ag=0; bg=0; cg=1; dg=0;  #20;
    ag=0; bg=0; cg=0; dg=1;  #20;

    // ahora ver la salida de Hamming (dato demo 0xA)
    sw_mode = 1'b1;           #80;

    // volver a switches
    sw_mode = 1'b0;           #40;

    $finish;
  end

  // monitoreo
  initial begin
    $display("time  sw_mode  Gray agbgcgdg  LED  U[a..g]  D[a..g]");
    $monitor("%4t     %0b        %b%b%b%b     %b   %b%b%b%b%b%b%b  %b%b%b%b%b%b%b",
             $time, sw_mode, ag,bg,cg,dg, led,
             au,bu,cu,du,eu,fu,gu, ad,bd,cd,dd,ed,fd,gd);
  end

endmodule

`default_nettype wire
