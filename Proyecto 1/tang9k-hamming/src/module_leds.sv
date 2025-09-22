module module_leds (
    input  logic [3:0] binario,
    output logic [3:0] led
);
    assign led[0] = ~((binario == 4'b0001)| (binario == 4'b0011)| (binario == 4'b0101) |
                      (binario == 4'b0111) | (binario == 4'b1001)| (binario == 4'b1011) |
                      (binario == 4'b1101) | (binario == 4'b1111)) ; 

    assign led[1] = ~((binario == 4'b0010) | (binario == 4'b0011) | (binario == 4'b0110) |
                      (binario == 4'b0111) | (binario == 4'b1010) | (binario == 4'b1011) |
                      (binario == 4'b1110) | (binario == 4'b1111)) ;

    assign led[2] = ~((binario == 4'b0100)| (binario == 4'b0101) | (binario == 4'b0111) |
                      (binario == 4'b0110)| (binario == 4'b1100)| (binario == 4'b1101) |
                      (binario == 4'b1111) | (binario == 4'b1110)) ;

    assign led[3] = ~((binario == 4'b1000)| (binario == 4'b1101) | (binario == 4'b1001) |
                      (binario == 4'b1010)| (binario == 4'b1011)| (binario == 4'b1100) |
                      (binario == 4'b1110) | (binario == 4'b1111));
endmodule
