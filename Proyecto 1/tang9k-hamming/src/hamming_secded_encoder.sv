`default_nettype none
module hamming_secded_encoder (
    input  logic [3:0] data,     // d3 d2 d1 d0
    output logic [7:0] code      // [0]=p1,[1]=p2,[2]=d0,[3]=p4,[4]=d1,[5]=d2,[6]=d3,[7]=p_overall
);
    logic p1, p2, p4, p_all;
    assign p1   = data[0] ^ data[1] ^ data[3]; // d0^d1^d3
    assign p2   = data[0] ^ data[2] ^ data[3]; // d0^d2^d3
    assign p4   = data[1] ^ data[2] ^ data[3]; // d1^d2^d3
    assign p_all = p1 ^ p2 ^ p4 ^ data[0] ^ data[1] ^ data[2] ^ data[3];

    assign code[0] = p1;
    assign code[1] = p2;
    assign code[2] = data[0];
    assign code[3] = p4;
    assign code[4] = data[1];
    assign code[5] = data[2];
    assign code[6] = data[3];
    assign code[7] = p_all;
endmodule

