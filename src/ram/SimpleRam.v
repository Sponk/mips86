
module SimpleRam
	#(parameter BUS_WIDTH = 8, parameter SIZE = 512, parameter ADDRESS_WIDTH = 32)
	(
		input wire clk,
		input wire reset,

		input wire [ADDRESS_WIDTH-1:0] addrA,
		input wire [BUS_WIDTH-1:0] dataIn,
		input wire writeEnable,

		input wire [ADDRESS_WIDTH-1:0] addrB,

		output reg [BUS_WIDTH-1:0] outA,
		output reg [BUS_WIDTH-1:0] outB,

		output reg busyA,
		output reg busyB
	);

	reg [BUS_WIDTH-1:0] memory[0:SIZE];

	reg [BUS_WIDTH-1:0] lastAddrA = 0;
	reg [BUS_WIDTH-1:0] lastAddrB = 0;

	always @(clk)
	begin
	
		if(writeEnable)
		begin
			outA <= dataIn;
			memory[addrA] <= dataIn;
		end
	
		if(addrA != lastAddrA)
			busyA <= 1;
			
		if(addrB != lastAddrB)
			busyA <= 1;
	
		if(~writeEnable)
		begin
			busyA <= 0;
			outA <= memory[addrA];

			busyB <= 0;
			outB <= memory[addrB];
		end
	
		lastAddrA = addrA;
		lastAddrB = addrB;
	
		if(reset)
		begin
			busyA <= 1;
			busyB <= 1;

			outA <= 0;
			outB <= 0;
		end
	end

endmodule
