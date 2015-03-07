
module Display
	(
		input wire clk,
		input wire [15:0] dataIn
	);

	always @(dataIn) 
	begin
		$display("Display: %4h", dataIn);
	end

endmodule

