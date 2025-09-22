// module_seg.sv (versión con polaridad paramétrica)
// Cátodo común + 2N2222: ACTIVE_HIGH_SEG = 1 (por defecto)
module module_seg #(
    parameter bit ACTIVE_HIGH_SEG = 1  // 1 = segmentos activos en alto (cátodo común)
) (
    input  logic       clk,
    input  logic       A, B, C, D,      // nibble binario (MSB=A ... LSB=D)
    output logic       au, bu, cu, du, eu, fu, gu,   // segmentos unidades
    output logic       ad, bd, cd, dd, ed, fd, gd    // segmentos décimas
);

    // codificador 7 segmentos para dígito 0..9 (a..g)
    function automatic logic [6:0] seg7(input logic [3:0] x);
        // a b c d e f g  (1 = encendido si ACTIVE_HIGH_SEG=1)
        case (x)
            4'd0: seg7 = 7'b1111110;
            4'd1: seg7 = 7'b0110000;
            4'd2: seg7 = 7'b1101101;
            4'd3: seg7 = 7'b1111001;
            4'd4: seg7 = 7'b0110011;
            4'd5: seg7 = 7'b1011011;
            4'd6: seg7 = 7'b1011111;
            4'd7: seg7 = 7'b1110000;
            4'd8: seg7 = 7'b1111111;
            4'd9: seg7 = 7'b1111011;
            default: seg7 = 7'b0000001; // guión medio (solo g) como fallback
        endcase
    endfunction

    // mismo valor en unidades y décimas (si quieres otro, divide aquí)
    logic [6:0] u7 = seg7({A,B,C,D});
    logic [6:0] d7 = u7;

    // Ajuste de polaridad (si algún día usas ánodo común -> ACTIVE_HIGH_SEG=0)
    logic [6:0] u_drive = ACTIVE_HIGH_SEG ? u7 : ~u7;
    logic [6:0] d_drive = ACTIVE_HIGH_SEG ? d7 : ~d7;

    // mapear a pines
    assign {au,bu,cu,du,eu,fu,gu} = u_drive;
    assign {ad,bd,cd,dd,ed,fd,gd} = d_drive;
endmodule
