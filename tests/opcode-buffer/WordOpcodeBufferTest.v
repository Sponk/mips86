
module WordOpcodeBufferTest;

	`include "Framework.v"

	reg reset;
	reg clk;

	always #10 clk = ~clk;

	reg [31:0] addrA;
	wire [31:0] addrB;

	reg writeEnable = 0;
	reg [31:0] dataIn;

	reg requestA;
	wire requestB;

	wire [31:0] outA;
	wire [31:0] outB;

	wire busyA;
	wire busyB;

	SimpleMmu #(.BUS_WIDTH(32)) mmu(clk, reset, addrA, addrB, writeEnable, dataIn, requestA, requestB, outA, outB, busyA, busyB);

	reg [31:0] ip;
	wire busy;
	wire [31:0] opcode;
	reg startLoading;
	
	WordOpcodeBuffer ob(clk, reset, ip, startLoading, outB, busyB, busy, opcode, addrB, requestB);

	initial begin
		
		$dumpfile("timing.vcd");
		$dumpvars(0,mmu,ob);

		reset = 1;
		clk = 0;
		#20 reset = 0;

		ip = 0;
		startLoading = 1;

		#300 @(negedge busy) $display("Word: Got opcode: %h = %h", ip, opcode);

		#10 startLoading = 0;

		ip = 4;
		startLoading = 1;
		#300 @(negedge busy) $display("Word: Got opcode: %h = %h", ip, opcode);

		ip = 8;
		startLoading = 1;
		#300 @(negedge busy) $display("Word: Got opcode: %h = %h", ip, opcode);

		$finish;		
	end
endmodule
