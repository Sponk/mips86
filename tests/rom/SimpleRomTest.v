
module SimpleRomTest;

	`include "Framework.v"

	reg reset;
	reg clk;

	wire [7:0] dataOut;
	wire [7:0] dataOutA;

	reg [31:0] address;
	reg [31:0] addressA;

	SimpleRom rom(clk, address, addressA, dataOut, dataOutA);

	always #10 clk = ~clk;

	integer i;
	initial begin
		clk = 0;
		reset = 1;

		#20 reset = 0;

		$display("ROM-Dump:");
		for(i = 0; i < 15; i = i + 1)
		begin
			addressA = i;
			address = i;

			#20 $display("Address: 0x%h == 0x%h", i, dataOut);
		end

		$finish;
	end

endmodule
