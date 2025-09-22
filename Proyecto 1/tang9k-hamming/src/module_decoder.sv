module decoder (
    input  logic ag, bg, cg, dg,    // Gray
    output logic ab, bb, cb, db     // Binario
);
    assign ab = ag;
    assign bb = ag ^ bg;
    assign cb = (ag ^ bg) ^ cg;
    assign db = ((ag ^ bg) ^ cg) ^ dg;
endmodule
