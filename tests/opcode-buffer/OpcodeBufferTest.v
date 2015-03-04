
module OpcodeBufferTest;

	`include "Framework.v"

	reg reset;
	reg clk;

	always #10 clk = ~clk;

	reg [31:0] addrA;
	wire [31:0] addrB;

	reg writeEnable = 0;
	reg [7:0] dataIn;

	reg requestA;
	wire requestB;

	wire [7:0] outA;
	wire [7:0] outB;

	wire busyA;
	wire busyB;

	SimpleMmu mmu(clk, reset, addrA, addrB, writeEnable, dataIn, requestA, requestB, outA, outB, busyA, busyB);

	/*input wire clk,
			input wire reset,
			input wire [ADDRESS_WIDTH-1:0] ip,
			input wire startLoading,

			input wire [7:0] ramData,
			input wire ramBusy,

			output reg busy,
			output reg [WORD_WIDTH-1:0] opcode,
			
			output reg [ADDRESS_WIDTH-1:0] address
*/
	reg [31:0] ip;
	wire busy;
	wire [31:0] opcode;
	reg startLoading;
	
	OpcodeBuffer ob(clk, reset, ip, startLoading, outB, busyB, busy, opcode, addrB, requestB);

	initial begin
		
		$dumpfile("timing.vcd");
		$dumpvars(0,mmu,ob);

		reset = 1;
		clk = 0;
		#20 reset = 0;

		ip = 0;
		startLoading = 1;

		#500 @(negedge busy) $display("Got opcode: %h", opcode);

		$finish;		
	end

endmodule
