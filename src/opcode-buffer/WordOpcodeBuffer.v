
module WordOpcodeBuffer
		#(parameter ADDRESS_WIDTH = 32, parameter WORD_WIDTH = 32)
		(
			input wire clk,
			input wire reset,
			input wire [ADDRESS_WIDTH-1:0] ip,
			input wire startLoading,

			input wire [WORD_WIDTH-1:0] ramData,
			input wire ramBusy,

			output reg busy,
			output reg [WORD_WIDTH-1:0] opcode,
			
			output reg [ADDRESS_WIDTH-1:0] address,
			output reg request
		);

	always @(posedge clk)
	begin
		request = 0;

		if(startLoading & ~busy)
		begin
			request = 1;
			busy = 1;
			address = ip;
		end
		else if(busy)
		begin
			if(~ramBusy)
			begin
				opcode = ramData;		
				busy = 0;
				request = 1;
			end
		end

		if(reset)
		begin
			opcode <= 0;
			address = 0;
			busy = 0;
		end
	end

endmodule
