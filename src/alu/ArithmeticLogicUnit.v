/**
 * This file containsn the arithmetic logic unit with following features:
 *
 * - Addition		=>		0x0
 * - Substraction	=>		0x1
 * - Shift left		=>		0x2
 * - Bitwise OR		=>		0x3
 * - Bitwise AND	=>		0x4
 * - Bitwise XOR	=>		0x5
 * - Rotate right	=>		0x6
 * - Equals		=> 		0x7
 * - Greater than	=>	 	0x8
 * - Smaller than	=>		0x9
 */

module ArithmeticLogicUnit
	#(parameter BUS_WIDTH = 8)
	(input wire [BUS_WIDTH-1:0] a,
	 input wire [BUS_WIDTH-1:0] b,
	 input wire [3:0] command,
	 input wire clk,
	 input wire reset,
	 
    output wire [BUS_WIDTH-1:0] out,
    output wire overflow
    );

	reg addcin;
	wire addcout;
	wire [BUS_WIDTH-1:0] adds;
	
	reg [BUS_WIDTH-1:0] adda;
	reg [BUS_WIDTH-1:0] addb;
	
	reg overflow_register;
	reg [BUS_WIDTH-1:0] output_register;
	
	assign out = output_register;
	assign overflow = overflow_register;
		
	BitAdder adder(.a(adda),.b(addb),.substract(addcin),.out(adds),.carry(addcout));

	always @(*)
	begin	
		if(reset)
		begin
			addcin = 0;
			adda = 0;
			addb = 0;
			overflow_register = 0;
			output_register = 0;
		end
	
		case(command)
			0: begin 
					addcin = 0;
					adda = a;
					addb = b;
					overflow_register = addcout; 
					output_register = adds;
				end
			1: begin
					addcin = 1;
					adda = a;
					addb = ~b;
					// overflow_register = addcout; 
					output_register = adds;
				end
				
			2: output_register = a << b;
			3: output_register = a | b;
			4: output_register = a & b;
			5: output_register = a ^ b;			
			
			6: output_register = (a << b) | (a >> ~b);
			
			7: overflow_register = (a == b);
			8: overflow_register = (a > b);
			9: overflow_register = (a < b);
			
			default:
				begin
					overflow_register = 0;
					output_register = 0;
				end
		endcase
	end
endmodule
