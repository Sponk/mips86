
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
			
			output reg [ADDRESS_WIDTH-1:0] address,
			output reg request
		);

	reg [7:0] operation[0:3];

	reg [3:0] counter = 0;
	reg [3:0] status = 0;

	integer i;
	initial begin
		for(i = 0; i < 4; i = i + 1)
		$dumpvars(0,operation[i]);
	end

	always @(posedge clk)
	begin
		request = 0;

		if(startLoading & ~busy)
		begin
			request = 1;
			busy = 1;
			address = ip;
			counter = 0;
		end
		else if(busy)
		begin
			if(~ramBusy)
			begin
				$display("Fetching opcode: %h = %h", address, ramData);
				
				operation[counter] = ramData;
				
				request = 1;
				counter = counter + 1;
				address = address + 1;

			end
		end

		if(busy && counter >= 4)
		begin
			counter = 0;
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
