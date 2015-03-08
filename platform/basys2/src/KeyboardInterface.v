
module KeyboardInterface
			#(parameter DELAY = 5000)
			(
				input clk,
				inout wire ps2data,
				
				inout wire ps2clk,
				output reg [7:0] char,
				output reg interrupt,
				output reg interruptType
			);

	reg [15:0] counter = 0;
	reg [7:0] previousValue = 0;
	reg [10:0] shiftRegister = 0;
	
	always @(negedge ps2clk)
	begin
			counter = counter + 1;
			shiftRegister = shiftRegister << 1;
			shiftRegister[0] = ps2data;
			
			if(counter == 11)
			begin
				counter = 0;
			end
	end
	
	always @(posedge clk)
	begin
			interrupt = 0;
			if(counter == 0 && shiftRegister[9:2] != 'hE0 && shiftRegister[9:2] != 'hF0)
			begin
				char = shiftRegister[9:2];
				interrupt = 1;
				interruptType = (previousValue == 'hF0) ? 1 : 0;
			end
			
			previousValue = shiftRegister[9:2];
	end
endmodule