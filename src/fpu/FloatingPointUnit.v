
module FloatingPointUnit
	#(parameter BUS_WIDTH = 32)
	(
		input wire [31:0] ain,
		input wire [31:0] bin,
		input wire [3:0] cmd,

		output reg [31:0] result
	);

	reg shift_count = 0;
	reg [23:0] mantissaA;
	reg [23:0] mantissaB;

	reg [24:0] tmpResult;
	reg [31:0] tmp;

	reg [31:0] a;
	reg [31:0] b;

	task add;	
	begin
		a = ain;
		b = bin;

		if(b[30:23] > a[30:23])
		begin
			tmp = a;
			a = b;
			b = tmp;
		end	

		mantissaA[22:0] = a[22:0];
		mantissaA[23] = 1;

		mantissaB[22:0] = b[22:0];
		mantissaB[23] = 1;

		shift_count = a[30:23] - b[30:23];

		mantissaB = mantissaB >> shift_count;
		tmpResult = (mantissaA + mantissaB); 
		
		if(result[0])
		begin
			result[30:23] = a[30:23] + 1;
			result[22:0] = tmpResult >> 1;
		end
		else
		begin
			result[22:0] = tmpResult;
			result[30:23] = a[30:23];
		end

		result[31] = a[31];
	end
	endtask

	always @(cmd or ain or bin)
	begin
		case(cmd)
			// ADD
			0: add();
		endcase
	end
endmodule
