module adder3bit (a, b, cin, sum, cout);

    input logic [3:0] a, b;
    input logic cin;
    output logic [4:0] sum;
    output logic cout;

    logic c1, c2, c3,   c4;

    adder u0 (.a(a[0]), .b(b[0] ^ cin), .cin(cin), .sum(sum[0]), .cout(c1));
    adder u1 (.a(a[1]), .b(b[1] ^ cin), .cin(c1), .sum(sum[1]), .cout(c2));
    adder u2 (.a(a[2]), .b(b[2] ^ cin), .cin(c2), .sum(sum[2]), .cout(c3));
    adder u3 (.a(a[3]), .b(b[3] ^ cin), .cin(c3), .sum(sum[3]), .cout(c4));
    adder u4 (.a(1'b0), .b(cin), .cin(c4), .sum(sum[4]), .cout(cout));

endmodule