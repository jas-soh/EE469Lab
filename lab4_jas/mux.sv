// 2:1 Mux
`timescale 1ps/1ps
module mux2_1 (s0, a, b, out);

	input logic a, b, s0;
	output logic out;
	
	logic temp0, temp1;
    logic not_s0;

    // 1 chooses B, 0 chooses A
    not #50 inv (not_s0, s0);	
	and #50 a0 (temp0, a, not_s0);
	and #50 b1 (temp1, b, s0);
	
	or #50 outp (out, temp0, temp1);
	
endmodule

// 3:1 Mux
`timescale 1ps/1ps
module mux3_1 (s0, a, b, c, out);

	input logic a, b, c;
	input logic [1:0] s0;
	output logic out;
	
	logic temp;
    logic [1:0] not_s0;

    // 0 chooses A, 1 chooses B, 2 chooses c
    mux2_1 mux1 (.s0(s0[0]), .a, .b, .out(temp));
	mux2_1 mux2 (.s0(s0[1]), .a(temp), .b(c), .out);
	
endmodule

module mux2_1_multi #(parameter SIZE = 64) (s0, a, b, out);
	input logic [SIZE-1:0] a, b;
	input logic s0;
	output logic [SIZE-1:0] out;

	genvar i;
	generate
		for (i = 0; i < SIZE; i++) begin : eachBit
			mux2_1 mux_multi (.s0, .a(a[i]), .b(b[i]), .out(out[i]));
		end
	endgenerate

endmodule

module mux3_1_multi #(parameter SIZE = 64) (s0, a, b, c, out);
	input logic [SIZE-1:0] a, b, c;
	input logic [1:0] s0;
	output logic [SIZE-1:0] out;

	genvar i;
	generate
		for (i = 0; i < SIZE; i++) begin : eachBit
			mux3_1 mux_multi (.s0, .a(a[i]), .b(b[i]), .c(c[i]), .out(out[i]));
		end
	endgenerate

endmodule

// 4:1 mux
module mux4_1 (s, ins, out);
	input logic [3:0] ins;
	input logic  [1:0] s;
	output logic out;
	
	logic temp0, temp1, temp2, temp3;
	logic [1:0] not_s;

	not #50 notgate1 (not_s[0], s[0]);
	not #50 notgate2 (not_s[1], s[1]);
	
	and #50 a0 (temp0, ins[0], not_s[1], not_s[0]);
	and #50 b1 (temp1, ins[1], not_s[1], s[0]);
	and #50 c2 (temp2, ins[2], s[1], not_s[0]);
	and #50 d3 (temp3, ins[3], s[1], s[0]);
	
	or #50 outp (out, temp0, temp1, temp2, temp3);
endmodule