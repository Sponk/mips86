
module OpcodeBuffer
		#(parameter ADDRESS_WIDTH = 32, parameter WORD_WIDTH = 32)
		(
			input wire [ADDRESS_WIDTH-1:0] address,
			input wire startLoading,

			input wire [7:0] ramData,
			input wire ramBusy,

			output reg busy,
			output reg [WORD_WIDTH-1:0] opcode,
			
			output reg [ADDRESS_WIDTH-1:0] address,
		)

	reg [7:0] operation[4];



endmodule
