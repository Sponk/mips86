
module SimpleDataflow(input wire clk, input wire reset);

	reg [31:0] addrA;
	wire [31:0] addrB;

	reg writeEnable = 0;
	reg [31:0] dataIn;

	reg requestA;
	wire requestB;

	wire [31:0] outA;
	wire [31:0] outB;

	wire busyA;
	wire busyB;

	wire [15:0] displayIn;
	wire [31:0] displayAddr;
	wire displayWE;
	Display dsp(clk, displayIn);

	wire [31:0] mmioInB;
	wire [31:0] mmioAddrB;
	wire mmioWEB;

	SimpleMmu #(.SHIFT(2), .BUS_WIDTH(32), .ROM_SIZE(1024), .RAM_SIZE(8192))
			mmu(clk, reset, addrA, addrB, writeEnable, dataIn, requestA, requestB, outA, outB, busyA, busyB,
				displayIn,displayAddr,displayWE, mmioInB, mmioAddrB, mmioWEB);

	reg [31:0] ip;
	wire busy;
	wire [31:0] opcode;
	reg [31:0] decodeOpcodeStage = 0;
	reg startLoading;
	
	WordOpcodeBuffer ob(clk, reset, ip, startLoading, outB, busyB, busy, opcode, addrB, requestB);

	reg resetCounter = 0;
	reg opcodeFetchDelay = 0;
	reg pipelineStall = 0;

	// ALU!
	wire [31:0] aluA;
	reg [31:0] aluB = 0;
	reg [3:0] aluControl = 0;

	wire [31:0] aluOut;
	wire aluOverflow;
	reg aluSubmitted = 0;

	ArithmeticLogicUnit #(.BUS_WIDTH(32)) 
		alu(aluA, aluB, aluControl, clk, reset, aluOut, aluOverflow);

	// Wires for opcode parsing
	// I-Type instructions
	wire [15:0] imm = decodeOpcodeStage[15:0];
	wire [5:0] op = decodeOpcodeStage[31:26];
	wire [4:0] rs = decodeOpcodeStage[25:21];
	wire [4:0] rt = decodeOpcodeStage[20:16];

	// R-Type instructions
	wire [4:0] rd = decodeOpcodeStage[15:11];
	wire [4:0] shamt = decodeOpcodeStage[10:6];
	wire [5:0] func = decodeOpcodeStage[5:0];

	reg signExtendSelect = 0;
	reg [15:0] signExtend = 0;
	wire [31:0] signExtendOut;
	wire [15:0] signExtendIn;

	reg signExtendMode = 1;

	WideMux2x1 #(.BUS_WIDTH(16)) signextender_mux(signExtendSelect, imm, signExtend, signExtendIn);
	SignExtender se(signExtendIn, signExtendMode, signExtendOut);

	reg [31:0] aluAValue = 0;
	reg aluASelect = 0;
	WideMux2x1 aluA_mux(aluASelect, signExtendOut, aluAValue, aluA);

	reg [31:0] registers[0:31];
	reg branching = 0;
	reg newOp = 0;

	integer i;
        initial begin
                for(i = 0; i < 32; i = i + 1)
                $dumpvars(0,registers[i]);
        end


	always @(posedge clk)
	begin
	
		if(newOp)
			aluSubmitted = 0;
	
		registers[0] = 0;
		opcodeFetchDelay = opcodeFetchDelay + 1;
		branching = 0;
		case(op)

			// R-Type instructions
			'b000000: begin
				case(func)
					// sll
					'b000000: begin
						if(~aluSubmitted)
						begin

							// NOP
							if(decodeOpcodeStage != 0)
							begin
								$display("0x%h\tsll %d %d %d", ip, rs,rt,shamt);
								signExtendMode = 0;
								signExtendSelect = 1;
								signExtend = shamt;
								aluControl = 2;
								aluB = registers[rt];				
							end
							else
								$display("0x%h\tnop", ip);
							aluSubmitted = 1;
						end	
						else
							registers[rd] = aluOut;	
					end

					// add
					'b100000: begin
						if(~aluSubmitted)
						begin
							$display("0x%h\tadd %d %d %d", ip, rs,rt,rd);
							signExtendSelect = 1;
							signExtend = registers[rs];
							aluControl = 0;
							aluB = registers[rt];
							aluSubmitted = 1;
						end	
						else
							registers[rd] = aluOut;	
					end
					
					// jr	
					'b001000: begin
						if(~aluSubmitted)
						begin
							$display("0x%h\tjr %d", ip, rs);
							ip = registers[rs];
							aluSubmitted = 1;
							resetCounter = 0;
							branching = 1;
						end	
					end

					// move
					'b101101: begin
						if(~aluSubmitted)
						begin
							$display("0x%h\tmove %d %d", ip, rs, rd);
							aluSubmitted = 1;
							registers[rd] = registers[rs];
						end
					end

					default: $display("0x%h\t Unknown R-Type instruction: 0x%h", ip, func);
				endcase
			end

			// I-Type instructions
			// addi
			'b001000: begin
				if(~aluSubmitted)
				begin
					$display("0x%h\taddi %d %d 0x%h", ip, rs, rt, imm);
					signExtendSelect = 0;
					signExtendMode = 1;
					aluControl = 0;
					aluB = registers[rs];
					//signExtendIn = imm;
					aluSubmitted = 1;
				end	
				else
					registers[rt] = aluOut;		
			end		

			// addiu (currently no difference to addi)
			'b001001: begin
				if(~aluSubmitted)
				begin
					$display("0x%h\taddiu %d %d 0x%h", ip, rs, rt, imm);
					signExtendSelect = 0;
					signExtendMode = 1;
					aluControl = 0;
					aluB = registers[rs];
					aluSubmitted = 1;
				end	
				else
					registers[rt] = aluOut;		
			end		

			// andi 
			'b001100: begin
				if(~aluSubmitted)
				begin
					$display("0x%h\tandi %d %d 0x%h", ip, rs, rt, imm);
					signExtendSelect = 0;
					signExtendMode = 0;

					aluControl = 4;
					aluB = registers[rs];
					//signExtendIn = imm;
					aluSubmitted = 1;
				end	
				else
					registers[rt] = aluOut;	
			end
			
			// ori 
			'b001101: begin
				if(~aluSubmitted)
				begin
					$display("0x%h\tori %d %d 0x%h", ip, rs, rt, imm);
					signExtendSelect = 0;
					signExtendMode = 0;
					aluControl = 3;
					aluB = registers[rs];
					//signExtendIn = imm;
					aluSubmitted = 1;
				end	
				else
					registers[rt] = aluOut;	
			end

			// lui
			'b001111: begin
				if(~aluSubmitted)
				begin
					$display("0x%h\tlui %d 0x%h", ip, rt, imm);

					signExtendMode = 0;
					signExtendSelect = 1;
					aluControl = 2; 
					signExtend = imm;
					aluB = 16;
					aluSubmitted = 1;
				end
				else
					registers[rt] = aluOut;
			end

			// J-Type instructions
			// j
			'b000010: begin
				if(~aluSubmitted)
				begin
					signExtendSelect = 1;
					ip = ip[31:28] | (decodeOpcodeStage[25:0] << 2);
					aluSubmitted = 1;
					branching = 1;
					resetCounter = 0;
					opcodeFetchDelay = 1;
					$display("0x%h\tj 0x%h", ip, ip);
				end
			end

			// beq
			'b000100: begin
				if(~aluSubmitted && registers[rs] == registers[rt])
				begin
					ip = ip + (imm << 2);
					$display("0x%h\tbeq 0x%h", ip, ip);
					aluSubmitted = 1;
					branching = 1;
				end
				else if(~aluSubmitted)
				begin
					ip = ip + 4;
					$display("0x%h\tbeq 0x%h", ip, ip);
					aluSubmitted = 1;
					branching = 1;

				end
			end

			// lw
			'b100011: begin
				if(~aluSubmitted)
				begin
					$display("0x%h\tlw %d 0x%h", ip, rt, rs + imm);
					aluSubmitted = 1;
					pipelineStall = 1;
					// FIXME: Use ALU for that!
					addrA = registers[rs] + imm;
					requestA = 1;
				end
				else if(~busyA)
				begin
					pipelineStall = 0;
					registers[rt] = outA;
					requestA = 0;
				end
			end

			// ld
			/*'b101111: begin
				if(~aluSubmitted)
				begin
					$display("0x%h\tlw %d 0x%h", ip, rt, rs + imm);
					aluSubmitted = 1;
					pipelineStall = 1;
					// FIXME: Use ALU for that!
					addrA = registers[rs] + imm;
					requestA = 1;
				end
				else if(~busyA)
				begin
					pipelineStall = 0;
					registers[rt] = outA;
					requestA = 0;
				end
			end*/
			// sd
			'b111111: begin
				if(~aluSubmitted)
				begin
					$display("0x%h\tsd %d 0x%h", ip, rt, rs + imm);
					aluSubmitted = 1;
					pipelineStall = 1;
					// FIXME: Use ALU for that!
					addrA = registers[rs] + imm;
					dataIn = registers[rt];
					requestA = 1;
					writeEnable = 1;
				end
				else if(~busyA)
				begin
					pipelineStall = 0;
					requestA = 0;
					writeEnable = 0;
				end
			end


			
			// sw
			'b101011: begin
				if(~aluSubmitted)
				begin
					$display("0x%h\tsw %d 0x%h", ip, rt, rs + imm);
					aluSubmitted = 1;
					pipelineStall = 1;
					// FIXME: Use ALU for that!
					addrA = registers[rs] + imm;
					dataIn = registers[rt];
					requestA = 1;
					writeEnable = 1;
				end
				else if(~busyA)
				begin
					pipelineStall = 0;
					requestA = 0;
					writeEnable = 0;
				end
			end

			// sb
			'b101000: begin
				if(~aluSubmitted)
				begin
					$display("0x%h\tsb %d 0x%h", ip, rt, rs + imm);
					aluSubmitted = 1;
					pipelineStall = 1;
					// FIXME: Use ALU for that!
					addrA = registers[rs] + imm;
					dataIn = ('hff & registers[rt]);
					requestA = 1;
					writeEnable = 1;
				end
				else if(~busyA)
				begin
					pipelineStall = 0;
					requestA = 0;
					writeEnable = 0;
				end
			end

			default: $display("Unknown opcode at 0x%h: 0x%h", ip, op);

		endcase
		
		if(reset)
		begin
			ip = 0;
			startLoading = 1;
			writeEnable = 0;
			dataIn = 0;
			requestA = 0;
			resetCounter = 0;
			decodeOpcodeStage = 0;
			pipelineStall = 0;
			opcodeFetchDelay = 0;

                	for(i = 0; i < 32; i = i + 1)
               			registers[i] = 0; 
		end

		//startLoading = 0;
		newOp = 0;
		if(~busy & resetCounter & ~pipelineStall & ~opcodeFetchDelay)
		begin
			newOp = 1;
			startLoading = 1;
			decodeOpcodeStage = opcode;
			opcodeFetchDelay = 0;		
	
			if(~branching)
				ip = ip + 4;
		end

		resetCounter = 1;
	end
endmodule
