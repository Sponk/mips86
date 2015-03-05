
module SimpleDataflow(input wire clk, input wire reset);

	reg [31:0] addrA;
	wire [31:0] addrB;

	reg writeEnable = 0;
	reg [7:0] dataIn;

	reg requestA;
	wire requestB;

	wire [7:0] outA;
	wire [7:0] outB;

	wire busyA;
	wire busyB;

	SimpleMmu mmu(clk, reset, addrA, addrB, writeEnable, dataIn, requestA, requestB, outA, outB, busyA, busyB);

	reg [31:0] ip;
	wire busy;
	wire [31:0] opcode;
	reg [31:0] decodeOpcodeStage = 0;
	reg startLoading;
	
	OpcodeBuffer ob(clk, reset, ip, startLoading, outB, busyB, busy, opcode, addrB, requestB);

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
								signExtendSelect = 1;
								signExtend = shamt;
								aluControl = 3;
								aluB = registers[rt];				
							end
							else
								$display("0x%h\tnop", ip);
							aluSubmitted = 1;
						end	
						else
							registers[rd] = aluOut;	
					end

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

					default: $display("0x%h\t Unknown R-Type instruction: 0x%h", ip, func);
				endcase
			end

			// I-Type instructions
			// addi
			'b001000: begin
				if(~aluSubmitted)
				begin
					$display("0x%h\taddi %d %d %h", ip, rs, rt, imm);
					signExtendSelect = 0;
					aluControl = 0;
					aluB = registers[rs];
					//signExtendIn = imm;
					aluSubmitted = 1;
				end	
				else
					registers[rt] = aluOut;		
			end		

			// andi 
			'b001100: begin
				if(~aluSubmitted)
				begin
					$display("0x%h\tandi %d %d %h", ip, rs, rt, imm);
					signExtendSelect = 0;

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
					$display("0x%h\tori %d %d %h", ip, rs, rt, imm);
					signExtendSelect = 0;
					aluControl = 3;
					aluB = registers[rs];
					//signExtendIn = imm;
					aluSubmitted = 1;
				end	
				else
					registers[rt] = aluOut;	
			end

			// j
			'b000010: begin
				if(~aluSubmitted)
				begin
					signExtendSelect = 1;
					//ip = opcode[25:0];
					ip = (ip & 'hF0000000) | (opcode[25:0] << 2);
					aluSubmitted = 1;
					branching = 1;
					resetCounter = 0;
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
