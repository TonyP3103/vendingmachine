    module milestone_1(clk, rst, nickel, dime, quarter, total,result_comp,state_check,soda);
        input logic clk, rst;
        input logic nickel, dime, quarter;
        output logic [4:0] total;
        output logic [4:0] result_comp;
        output logic [2:0] state_check;
        output logic soda;

        logic [3:0] coin_value;
        logic [3:0] coin_input;
        logic [4:0] new_total;
        logic cout;
        logic acc_reset;
        logic [3:0] comp_input;

        logic [4:0] result_comp_q,result_comp_d;
        logic coin_enable;

    assign coin_input = coin_enable ? coin_value : 4'b0000;

        typedef enum logic [1:0] {  RST = 2'b00,
                                ACCUMULATE = 2'b01,
                                DONE = 2'b10} state_t;

    state_t state_q, state_d;

        always_ff @(posedge clk or negedge rst) begin
            if (!rst)
                state_q <= RST;
            else
                state_q <= state_d;
        end
        always_comb begin
            state_d = state_q; // Default state
            comp_input = 4'b0100;
                        acc_reset = 1'b0;
            soda = 1'b0;
            case (state_q)
                RST: begin
                    if (!rst) begin
                        acc_reset = 1'b1;
                        comp_input = 4'b0100;
                            state_check = 0;
                            coin_enable = 1'b0;
                            soda = 1'b0;
                            state_d = RST;
                    end else begin
                        coin_enable = 1'b1;
                        acc_reset = 1'b0;
                        comp_input = 4'b0100;
                        state_check = 3'b001;
                          soda = 1'b0;
                        state_d = ACCUMULATE;
                end
                end
                ACCUMULATE: begin
                    if (new_total[4] | new_total[3] | new_total[2]) begin
                        comp_input = new_total[3:0];
                        state_check = 3'b010;
                        acc_reset = 1'b0;
                        coin_enable = 1'b0;
                          soda = 1'b0;
                        state_d = DONE;
                    end else begin
                        soda = 1'b0;
                        coin_enable = 1'b1;
                            acc_reset = 1'b0;
                        comp_input = 4'b0100;
                        state_check = 3'b011;
                        state_d = ACCUMULATE;
                end
                end
                DONE: begin
                    comp_input = 4'b0100;
                    acc_reset = 1'b1;
                    state_check = 3'b0100;
                    coin_enable = 1'b1;
                    soda = 1'b1;
                    state_d = ACCUMULATE;
                end
                default: begin
                    state_d = RST;
                        
                end
            endcase
        end

        coin_insert coin_insert_1 (
            .nickel(nickel),
            .dime(dime),
            .quarter(quarter),
            .coin_out(coin_value)
        );

        adder3bit accumulate (
            .a(coin_value),
            .b(total[2:0]),
            .cin(1'b0),
            .sum(new_total),
            .cout(cout)
        );

        adder3bit comparator (
            .a(comp_input),
            .b(4'b0100),
            .cin(1'b1),
            .sum(result_comp_d),
            .cout()
        );

        always_ff @(posedge clk or negedge rst) begin
            if (!rst) begin
                total <= 4'b0000;
                result_comp_q <= 5'b00000;
            end else if (acc_reset) begin
                total <= 4'b0000;
                result_comp_q <= result_comp_d;
            end else begin
                result_comp_q <= result_comp_d;
                total <= new_total;
            end
        end

    assign result_comp = result_comp_q;
    endmodule
