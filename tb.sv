module tb();
    logic clk, rst;
    logic nickel, dime, quarter;
    logic [4:0] total;
    logic [4:0] result_comp;
    logic [2:0] state_check;
    logic soda;
  milestone_1 DUT (
        .clk(clk),
        .rst(rst),
        .nickel(nickel),
        .dime(dime),
        .quarter(quarter),
        .total(total),
        .state_check(state_check),
        .soda(soda),
        .result_comp(result_comp)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        nickel = 0;
        dime = 0;
        quarter = 0;
        rst = 1'b0;
        #10;
        rst = 1'b1;
        #10;
        // apply 32 random coin inputs (each is a 3-bit value 0..7 mapped to {nickel,dime,quarter})
        for (int i = 0; i < 32; i++) begin
            @(posedge clk);
            // choose only 001, 000, 010, or 100
            case ($urandom_range(0,3))
            0: {nickel,dime,quarter} = 3'b001;
            1: {nickel,dime,quarter} = 3'b000;
            2: {nickel,dime,quarter} = 3'b010;
            3: {nickel,dime,quarter} = 3'b100;
            endcase
        end
        // clear inputs and finish
        @(posedge clk);
        nickel = 0;
        dime = 0;
        quarter = 0;
        #10;
        $finish;
    end

endmodule 