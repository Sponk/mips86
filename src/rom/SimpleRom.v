/**
 * This module contains a preconfigured ROM with some startup procedures
 */
module SimpleRom
	#(parameter BUS_WIDTH = 8,
	  parameter SELECT_WIDTH = 32,
	  parameter MEMORY_SIZE = 128) // Size in byte
	  
	(
		input wire clk,
		input wire [SELECT_WIDTH-1:0] select,
		input wire [SELECT_WIDTH-1:0] selectA,

		output reg [BUS_WIDTH-1:0] dataOut,
		output reg [BUS_WIDTH-1:0] dataOutA
	);
	
	parameter initfile = "kernel.hex";

	reg [BUS_WIDTH-1:0] data [0:MEMORY_SIZE-1];

	initial $readmemh(initfile, data);

	always @(clk)
	begin
		dataOut <= data[select];
		dataOutA <= data[selectA];
	end
endmodule	
