module coin_insert (nickel, dime, quarter, coin_out);
    input logic nickel, dime, quarter;
    output logic [3:0] coin_out;

    always_comb begin
        case ({quarter, dime, nickel})
            3'b001: coin_out = 4'b0001; 
            3'b010: coin_out = 4'b0010; 
            3'b100: coin_out = 4'b0101; 
            default: coin_out = 4'b0000; 
        endcase
    end


endmodule