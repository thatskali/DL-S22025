`default_nettype none
module hamming_secded_decoder (
    input  logic [7:0] r,             // código recibido
    output logic [3:0] data,          // d3..d0 corregido
    output logic       single_error,
    output logic       double_error
);
    logic [2:0] syn;
    logic ov_err;
    logic [7:0] corr;

    hamming_secded_syndrome u_syn(.r(r), .syn(syn), .overall_err(ov_err));
    hamming_secded_corrector u_cor(
        .r(r), .syn(syn), .overall_err(ov_err),
        .corrected(corr), .single_error(single_error), .double_error(double_error)
    );

    assign data = {corr[6], corr[5], corr[4], corr[2]}; // d3,d2,d1,d0
endmodule

