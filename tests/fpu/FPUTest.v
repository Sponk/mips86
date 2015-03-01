
module FpuTest;

	`include "Framework.v"

	reg clk = 0;
	reg reset = 0;

	reg [31:0] a;
	reg [31:0] b;
	reg [3:0] cmd;
	wire [31:0] result;

	FloatingPointUnit uut(a,b,cmd,result);

	initial begin
		reset = 1;
		#20 reset = 0;

		// cmd == ADD
		cmd = 0;
		a = 32'b01000000010010001111010111000011;
		b = 0;

		#10 display_test_bin(32'b01000000010010001111010111000011, result);

		b = a;
		#40 display_test_bin(32'b01000000110010001111010111000011, result);

		b = result;
		#40 display_test_bin(32'b01000001000101101011100001010010, result);

		#100 $finish;
	end

	always #10 clk = ~clk;

endmodule
