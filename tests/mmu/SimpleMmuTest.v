
module SimpleMmuTest;

	`include "Framework.v"

	reg reset;
	reg clk;

	reg [31:0] addrA;
	reg [31:0] addrB;

	reg writeEnable = 0;
	reg [7:0] dataIn;

	reg requestA;
	reg requestB;

	wire [7:0] outA;
	wire [7:0] outB;

	wire busyA;
	wire busyB;

	wire [15:0] displayIn = 0;
	wire [31:0] displayAddr;
	wire displayWE;
	Display dsp(clk, displayIn);

	wire [31:0] mmioInB;
	wire [31:0] mmioAddrB;
	wire mmioWEB;

	SimpleMmu mmu(clk, reset, addrA, addrB, writeEnable, dataIn, requestA, requestB, outA, outB, busyA, busyB, 
			displayIn,displayAddr,displayWE, mmioInB, mmioAddrB, mmioWEB);

	always #10 clk = ~clk;

	integer i;
	integer j;
	initial begin
	
		$dumpfile("timing.vcd");
		$dumpvars(0,mmu);

		reset = 1;
		clk = 0;
		writeEnable = 0;

		#20 reset = 0;

		for(i = 0; i < 16; i = i + 1)
		begin
			addrA = i;
			addrB = i;

			requestA = 1;
			requestB = 1;

			@(negedge busyA) $display("Address: 0x%h = 0x%h, 0x%h", i, outA, outB);

			requestA = 0;
			requestB = 0;
		end
	
		j = 0;
		for(i = 360; i < 375; i = i + 1)
		begin
			addrA = i;
			
			dataIn = j;
	
			writeEnable = 1;
			requestA = 1;
			#100 writeEnable = 0;			
			requestA = 0;	
			j = j + 1;
		end
	
		for(i = 360; i < 375; i = i + 1)
		begin
			addrA = i;

			requestA = 1;

			#100 $display("Address: 0x%h = 0x%h", i, outA);

			requestA = 0;
		end
		$finish;
	end
endmodule
