
module OpcodeBuffer
		#(parameter ADDRESS_WIDTH = 32, parameter WORD_WIDTH = 32)
		(
			input wire clk,
			input wire reset,
			input wire [ADDRESS_WIDTH-1:0] ip,
			input wire startLoading,

			input wire [7:0] ramData,
			input wire ramBusy,

			output reg busy,
			output reg [WORD_WIDTH-1:0] opcode,
			
			output reg [ADDRESS_WIDTH-1:0] address
		);

	reg [7:0] operation[0:3];

	reg [3:0] counter = 0;
	reg [3:0] status = 0;

	always @(posedge clk)
	begin

		if(startLoading & ~busy)
		begin
			busy = 1;
			address = ip;
			counter = 0;
		end
		else if(busy)
		begin
			if(~ramBusy)
			begin
				counter = counter + 1;
				address = address + 1;

				operation[counter] = ramData;
			end
		end

		if(counter >= 3)
		begin
			busy = 0;
			opcode[WORD_WIDTH-1:WORD_WIDTH-9] <= operation[0];
			opcode[WORD_WIDTH-10:WORD_WIDTH-18] <= operation[1];
			opcode[WORD_WIDTH-19:0] <= operation[2];

		end
	
		if(reset)
		begin
			counter <= 0;
			status <= 0;
			opcode <= 0;
			address <= 0;
			busy <= 0;
		end
	end

endmodule
