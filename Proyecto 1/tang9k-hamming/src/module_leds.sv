`timescale 1ns/1ps
`default_nettype none

module module_leds (
    input  logic [3:0] binario,
    output logic [3:0] led
);
    // Directo y claro: los LEDs muestran el binario (ajusta si tus LEDs son activos en bajo)
    assign led = binario;
endmodule

`default_nettype wire
