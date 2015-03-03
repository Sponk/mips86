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
	 output reg [BUS_WIDTH-1:0] dataOut
    );
	
	 parameter initfile = "kernel.hex";

reg [BUS_WIDTH-1:0] data [0:MEMORY_SIZE-1];

initial
begin
	$readmemh(initfile, data);
end

always @(posedge clk or negedge clk)
begin
	dataOut <= data[select];
end

endmodule
