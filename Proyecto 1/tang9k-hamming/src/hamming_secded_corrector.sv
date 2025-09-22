`default_nettype none
module hamming_secded_corrector (
    input  logic [7:0] r,
    input  logic [2:0] syn,
    input  logic       overall_err,
    output logic [7:0] corrected,
    output logic       single_error,
    output logic       double_error
);
    function automatic [7:0] flip7_0(input [7:0] v, input [2:0] pos1to7);
        flip7_0 = v;
        unique case (pos1to7)
            3'd1: flip7_0[0] = ~v[0];
            3'd2: flip7_0[1] = ~v[1];
            3'd3: flip7_0[2] = ~v[2];
            3'd4: flip7_0[3] = ~v[3];
            3'd5: flip7_0[4] = ~v[4];
            3'd6: flip7_0[5] = ~v[5];
            3'd7: flip7_0[6] = ~v[6];
            default: /* no-op */ ;
        endcase
    endfunction

    logic [7:0] tmp;
    logic se, de;

    always_comb begin
        tmp = r;
        se  = 1'b0;
        de  = 1'b0;

        if (syn != 3'd0 && overall_err) begin
            // Error de 1 bit en posiciones 1..7
            tmp = flip7_0(r, syn);
            se  = 1'b1;
        end
        else if (syn == 3'd0 && overall_err) begin
            // Error sólo en paridad global (bit 7)
            tmp[7] = ~r[7];
            se  = 1'b1;
        end
        else if (syn != 3'd0 && !overall_err) begin
            // Doble error (síndrome ≠0 pero paridad total correcta)
            de  = 1'b1;
            // dejamos r tal cual
        end
        // else: sin error
    end

    assign corrected    = tmp;
    assign single_error = se;
    assign double_error = de;
endmodule
