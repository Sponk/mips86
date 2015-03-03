
module SimpleRamTest;

	`include "Framework.v"

	reg reset;
	reg clk;
	reg [7:0] addrA;
	reg [7:0] dataIn;
	reg writeEnable;

	reg [7:0] addrB;
	wire [7:0] outA;
	wire [7:0] outB;
	wire busyA;
	wire busyB;

	SimpleRam ram(clk, reset, addrA, dataIn, writeEnable, addrB, outA, outB, busyA, busyB);

	always #10 clk = ~clk;

	initial begin
		clk = 0;
		reset = 1;

		#20 reset = 0;

		addrA = 10;
		dataIn = 50;
		writeEnable = 1;

		#10 display_test(50, outA);	

		writeEnable = 0;

		addrA = 10;
		addrB = 10;
		#10 display_test(50, outA);
		display_test(50, outB);

		$finish;
	end

endmodule
