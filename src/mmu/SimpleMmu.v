
module SimpleMmu
	#(
		parameter ROM_SIZE = 256,
		parameter RAM_SIZE = 512,
		parameter BUS_WIDTH = 8, 
		parameter ADDRESS_WIDTH = 32
	)
	(
		input wire clk,
		input wire reset,

		input wire [ADDRESS_WIDTH-1:0] addrA,
		input wire [ADDRESS_WIDTH-1:0] addrB,

		input wire writeEnable,
		input wire [BUS_WIDTH-1:0] dataIn,

		input wire requestA,
		input wire requestB,

		output reg [BUS_WIDTH-1:0] outA,
		output reg [BUS_WIDTH-1:0] outB,
		output wire busyA,
		output wire busyB
	);

	reg [ADDRESS_WIDTH-1:0] physAddrA = 0;
	reg [ADDRESS_WIDTH-1:0] physAddrB = 0;

	wire [BUS_WIDTH-1:0] ramOutA;
	wire [BUS_WIDTH-1:0] ramOutB;

	wire [BUS_WIDTH-1:0] romOutA;
	wire [BUS_WIDTH-1:0] romOutB;

	reg portABusy = 0;
	reg portBBusy = 0;

	reg regBusyA = 0;
	reg regBusyB = 0;

	assign busyA = regBusyA;
	assign busyB = regBusyB;

	wire ramBusyA;
	wire ramBusyB;

	reg ramWriteEnable = 0;

	SimpleRam ram(clk, reset, physAddrA, dataIn, ramWriteEnable, physAddrB, ramOutA,
				ramOutB, ramBusyA, ramBusyB);

	SimpleRom rom(clk, physAddrA, physAddrB, romOutA, romOutB);

	reg romCounter = 0;
	reg srcA = 0;
	reg srcB = 0;

	always @(negedge writeEnable) ramWriteEnable = 0;

	always @(posedge clk)
	begin
		if(requestA & ~regBusyA)
		begin

			if(addrA < ROM_SIZE)
			begin
				srcA = 0;
				regBusyA = 1;
				romCounter = 0;
				physAddrA = addrA;
			end
			else
			begin
				srcA = 1;
				ramWriteEnable = writeEnable;
				regBusyA = 1;
				physAddrA = addrA - ROM_SIZE;
			end
		end

		if(requestB & ~regBusyB)
		begin
			if(addrB < ROM_SIZE)
			begin
				srcB = 0;
				regBusyB = 1;
				romCounter = 0;
				physAddrB = addrB;
			end
			else
			begin
				srcB = 1;
				regBusyB = 1;
				physAddrB = addrB - ROM_SIZE;
			end
		end

		if(srcA & regBusyA & ~ramBusyA)
		begin
			regBusyA = 0;
			outA = ramOutA;
		end
		else if(~srcA & regBusyA & romCounter)
		begin
			regBusyA = 0;
			outA = romOutA;
		end

		if(srcB & regBusyB & ~ramBusyB)
		begin
			regBusyB = 0;
			outB = ramOutB;
		end
		else if(~srcB & regBusyB & romCounter)
		begin
			regBusyB = 0;
			outB = romOutB;
		end

		romCounter = ~romCounter;
	end
endmodule
