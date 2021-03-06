// This is the top level module for the ALU.
// Inputs:
//		6-bit A,B: values that will be operated on
//		1-bit cntrl: control signal to indicate operation
// Outpits:
//		64-bit result: result of the ALU operation
//		1-bit negative, zero, overflow, carry_out: flags
`timescale 1ps/1ps
module alu (A, B, cntrl, result, negative, zero, overflow, carry_out_flag);
	input logic [63:0] A, B;
   input logic [2:0] cntrl;
   output logic [63:0] result;
	output logic negative, zero, overflow, carry_out_flag;

    // cntrl			Operation						Notes:
    // 000:			result = B						value of overflow and carry_out unimportant
    // 010:			result = A + B
    // 011:			result = A - B
    // 100:			result = bitwise A & B		value of overflow and carry_out unimportant
    // 101:			result = bitwise A | B		value of overflow and carry_out unimportant
    // 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

    // 010:			result = A + B
    // 011:			result = A - B
    logic subtract_signal;
    logic [63:0] sum, carry_out;
    assign subtract_signal = cntrl[0];
    add_subtract adder (.A, .B, .subtract_signal, .sum, .carry_out);

    // 100:			result = bitwise A & B		value of overflow and carry_out unimportant
    logic [63:0] and_result;
    AND_func andgate (.A, .B, .out(and_result));

    // 101:			result = bitwise A | B		value of overflow and carry_out unimportant
    logic [63:0] or_result;
    OR_func orgate (.A, .B, .out(or_result));

    // 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant
    logic [63:0] xor_result;
    XOR_func xorgate (.A, .B, .out(xor_result));

    genvar i;
    generate
        for (i = 0; i < 64; i++) begin : choose_out
            mux8_1 mux (.sel(cntrl), .d({1'bx,xor_result[i],or_result[i],and_result[i],sum[i],sum[i],1'bx,B[i]}),  .out(result[i]));
        end
    endgenerate

    // flags
    flags flag (.out_result(result), .carries(carry_out[63:62]), .negative, .zero, .overflow, .carry_out(carry_out_flag));

endmodule

`timescale 1ns/1ns
module alu_testbench();
    logic [63:0] A, B;
    logic [2:0] cntrl;
    logic [63:0] result;
	 logic negative, zero, overflow, carry_out_flag;

    alu dut (.*);

    initial begin
        // test result = B
        A = '1; B = '1; cntrl = 3'b0; #10;
        assert (result == '1);
        A = '1; B = '0; cntrl = 3'b0; #10;
        assert (result == '0);

        // test OR
        A = '1; B = '0; cntrl = 3'b101; #10; // (1 | 0) for all bits
	    assert (result == '1);
        A = '0; B = '0; cntrl = 3'b101; #10; // (0 | 0) for all bits
        assert (result == '0);

        // test AND
        A = '1; B = '0; cntrl = 3'b100; #10;
        assert (result == '0);
        A = '1; B = '1; cntrl = 3'b100; #10;
        assert (result == '1);

        // test add
        A = '1; B = '0; cntrl = 3'b010; #10;
        assert (result == '1);
        A = '1; B = '1; cntrl = 3'b010; #10;
        assert (result == {{63{1'b1}},1'b0});

        // test subtract
        A = '1; B = '0; cntrl = 3'b011; #10;
        assert (result == '1);
        A = '1; B = '1; cntrl = 3'b011; #10;
        assert (result == '0);
    end
endmodule