/**
 * This module contains a preconfigured ROM with some startup procedures
 */
module SimpleRom
	#(parameter BUS_WIDTH = 8,
	  parameter SELECT_WIDTH = 32,
	  parameter SIZE = 128) // Size in byte
	  
	(
		input wire clk,
		input wire [SELECT_WIDTH-1:0] select,
		input wire [SELECT_WIDTH-1:0] selectA,

		output reg [BUS_WIDTH-1:0] dataOut,
		output reg [BUS_WIDTH-1:0] dataOutA
	);
	
	parameter initfile = "kernel.hex";

	reg [BUS_WIDTH-1:0] data [0:SIZE-1];

	integer i;
	initial begin

		for(i = 0; i < SIZE; i = i + 1)
			data[i] = 0;		

		$readmemh(initfile, data);
	end

	always @(clk)
	begin
		dataOut <= data[select];
		dataOutA <= data[selectA];
	end
endmodule	
