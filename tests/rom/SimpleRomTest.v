
module SimpleRomTest;

	`include "Framework.v"

	reg reset;
	reg clk;

	wire [7:0] dataOut;
	reg [31:0] address;

	SimpleRom rom(clk, address, dataOut);

	always #10 clk = ~clk;

	initial begin
		clk = 0;
		reset = 1;

		#20 reset = 0;

		address = 0;
		
		#10 test_nequal_hex(8'b0, dataOut);

		$finish;
	end

endmodule
