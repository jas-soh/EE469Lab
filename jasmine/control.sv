module control(instr, branch, ALUzeroFlag, Reg2Loc, ALUSrc, MemToReg, RegWrite, MemWrite, BrTaken, UncondBr, ALUOp, setFlag, shiftSel, immSize, read_enable);
	input logic [31:0] instr;
	input logic branch, ALUzeroFlag;
	output logic Reg2Loc, ALUSrc,
		MemToReg, RegWrite,
		MemWrite, BrTaken,
		UncondBr;
	output logic [2:0] ALUOp;
	output logic setFlag, shiftSel, immSize, read_enable; // readMem;
	
	always_comb begin
		// ---- R type ----
		// ADDI
		// ADDI Rd, Rn, Imm12: Reg[Rd] = Reg[Rn] + ZeroExtend(Imm12). 
		if (instr[31:22] == 10'h244) begin
			Reg2Loc = 1'bx;
			ALUSrc = 1'b1;
			MemToReg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b010;
			// ----
			setFlag = 0;
			shiftSel = 0;
			immSize = 1;
			read_enable = 0;
		end

		// ADDS
		// ADDS Rd, Rn, Rm: Reg[Rd] = Reg[Rn] + Reg[Rm]. Set flags.
		else if (instr[31:21] == 11'h558) begin
			Reg2Loc = 1'b1;
			ALUSrc = 1'b0;
			MemToReg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b010;
			// ----
			setFlag = 1;
			shiftSel = 0;
			immSize = 1'bx;
			read_enable = 0;
		end

		// AND
		// AND Rd, Rn, Rm: Reg[Rd] = Reg[Rn] & Reg[Rm]. 
		else if (instr[31:21] == 11'h450) begin
			Reg2Loc = 1'b1;
			ALUSrc = 1'b0;
			MemToReg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b100;
			// ----
			setFlag = 0;
			shiftSel = 0;
			immSize = 1'bx;
			read_enable = 0;
		end
		
		// EOR
		else if (instr[31:21] == 11'h650) begin
			Reg2Loc = 1'b1;
			ALUSrc = 1'b0;
			MemToReg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b110;
			// ----
			setFlag = 0;
			shiftSel = 0;
			immSize = 1'bx;
			read_enable = 0;
		end

		// LSR
		// LSR Rd, Rn, Shamt: Reg[Rd] = Reg[Rn] >> Shamt 
		else if (instr[31:21] == 11'h69A) begin
			Reg2Loc = 1'bx;
			ALUSrc = 1'bx;
			MemToReg = 1'bx;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'bxxx;
			// ----
			setFlag = 0;
			shiftSel = 1;
			immSize = 1'bx;
			read_enable = 0;
		end

		// SUBS
		// SUBS Rd, Rn, Rm: Reg[Rd] = Reg[Rn] - Reg[Rm].  Set flags. 
		else if (instr[31:21] == 11'h758) begin
			Reg2Loc = 1'b1;
			ALUSrc = 1'b0;
			MemToReg = 1'b0;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b011;
			// -----
			setFlag = 1;
			shiftSel = 0;
			immSize = 1'bx;
			read_enable = 0;
		end
		
		// ---- D-type ----
		// STUR 
		// STUR Rd, [Rn, #Imm9]: Mem[Reg[Rn] + SignExtend(Imm9)] = Reg[Rd].
		else if (instr[31:21] == 11'h7C0) begin
			Reg2Loc = 1'b0;
			ALUSrc = 1'b1;
			MemToReg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b1;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b010;
			// ----
			setFlag = 0;
			shiftSel = 0;
			immSize = 0;
			read_enable = 0;
		end

		// LDUR
		// LDUR Rd, [Rn, #Imm9]: Reg[Rd] = Mem[Reg[Rn] + SignExtend(Imm9)]. 
		else if (instr[31:21] == 11'h7C2) begin
			Reg2Loc = 1'bx;
			ALUSrc = 1'b1;
			MemToReg = 1'b1;
			RegWrite = 1'b1;
			MemWrite = 1'b0;
			BrTaken = 1'b0;
			UncondBr = 1'bx;
			ALUOp = 3'b010;
			// ----
			setFlag = 0;
			shiftSel = 0;
			immSize = 0;
			read_enable = 1;
		end
		
		// ---- CB-type ----
		// B
        // B Imm26: PC = PC + SignExtend(Imm26 << 2). 
		else if (instr[31:26] == 6'h05) begin
			Reg2Loc = 1'bx;
			ALUSrc = 1'bx;
			MemToReg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 1'b1;
			UncondBr = 1'b1;
			ALUOp = 3'bx;
            // ----
            setFlag = 0;
			shiftSel = 0;
			immSize = 1'bx;
			read_enable = 0;
		end

		// B.LT
        // B.LT Imm19: If (flags.negative != flags.overflow) PC = PC + SignExtend(Imm19<<2). 
		else if ((instr[31:24] == 8'h54) && (instr[4:0] == 5'h0B)) begin
			Reg2Loc = 1'bx;
			ALUSrc = 1'bx;
			MemToReg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = branch;
			UncondBr = 1'b0;
			ALUOp = 3'bx;
            // ----
            setFlag = 0;
			shiftSel = 0;
			immSize = 1'bx;
			read_enable = 0;
		end
		
		// CBZ
        // CBZ Rd, Imm19: If (Reg[Rd] == 0) PC = PC + SignExtend(Imm19<<2). 
		else if (instr[31:24] == 8'hB4) begin
			Reg2Loc = 1'b0;
			ALUSrc = 1'b0;
			MemToReg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = ALUzeroFlag; // zero flag
			UncondBr = 1'b0;
			ALUOp = 3'b000;
            // ----
            setFlag = 1;
			shiftSel = 0;
			immSize = 1'bx;
			read_enable = 0;
		end

		else begin
			Reg2Loc = 1'bx;
			ALUSrc = 1'bx;
			MemToReg = 1'bx;
			RegWrite = 1'b0;
			MemWrite = 1'b0;
			BrTaken = 1'bx;
			UncondBr = 1'bx;
			ALUOp = 3'bxxx;
            // ----
            setFlag = 1'bx;
			shiftSel = 1'bx;
			immSize = 1'bx;
			read_enable = 0;
		end
	end
	
endmodule 

`timescale 1ns/1ns
module control_testbench ();
    logic [31:0] instr;
	logic branch, ALUzeroFlag;
	logic Reg2Loc, ALUSrc,
		MemToReg, RegWrite,
		MemWrite, BrTaken,
		UncondBr;
	logic [2:0] ALUOp;
	logic setFlag, shiftSel, immSize, read_enable; // readMem;

    control dut (.*);

    initial begin
        // ADDI
		// ADDI Rd, Rn, Imm12: Reg[Rd] = Reg[Rn] + ZeroExtend(Imm12)
        instr = 32'b10010001000000000000001111100000; branch = 1'bx; ALUzeroFlag = 1'bx; #10; // ADDI X0, X31, #0     // X0 = 0
        assert ((ALUSrc == 1'b1) && (MemToReg == 1'b0) && (RegWrite == 1'b1)
			&& (MemWrite == 1'b0) && (BrTaken == 1'b0) && (ALUOp == 3'b010) && (setFlag == 0));

		// SUBS
		// SUBS Rd, Rn, Rm: Reg[Rd] = Reg[Rn] - Reg[Rm].  Set flags.
        instr = 32'b11101011000000000000001111100001; branch = 1'bx; ALUzeroFlag = 1'bx; #10; // SUBS X1, X31, X0     // X1 = -1
		assert ((Reg2Loc == 1'b1) && (ALUSrc == 1'b0) && (MemToReg == 1'b0)	&& (RegWrite == 1'b1) 
			&& (MemWrite == 1'b0)&& (BrTaken == 1'b0) 
			&& (ALUOp == 3'b011) 
			&& (setFlag == 1));

		// ADDS
		// ADDS Rd, Rn, Rm: Reg[Rd] = Reg[Rn] + Reg[Rm]. Set flags.
		instr = 32'b10101011000001000000000001100101; branch = 1'bx; ALUzeroFlag = 1'bx; #10; // ADDS X5, X3, X4      // X5 = -5
		assert ((Reg2Loc == 1'b1) &&  (ALUSrc == 1'b0) && (MemToReg == 1'b0) && (RegWrite == 1'b1) && (MemWrite == 1'b0) && (BrTaken == 1'b0)
			&& (ALUOp == 3'b010) && (setFlag == 1));

		// CBZ
        // CBZ Rd, Imm19: If (Reg[Rd] == 0) PC = PC + SignExtend(Imm19<<2). 
		instr = 32'b10110100000000000000001010011111; branch = 1'bx; ALUzeroFlag = 1'b1; #10; // CBZ X31, FORWARD_CBZ // 3rd taken branch (+20)
		assert ((Reg2Loc == 1'b0) && (ALUSrc == 1'b0) && (RegWrite == 1'b0)	&&	(MemWrite == 1'b0)
			&& (BrTaken == 1'b1) && (UncondBr == 1'b0) &&	(ALUOp == 3'b000) && (setFlag == 0));
    end

endmodule