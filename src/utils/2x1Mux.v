
module Mux2x1(
		input wire s,
		input wire a,
		input wire b,
		output wire q
);

	assign q = (~s & a) | (s & b);

endmodule

module WideMux2x1
#(parameter BUS_WIDTH = 32)
(
		input wire s,
		input wire [BUS_WIDTH-1:0] a,
		input wire [BUS_WIDTH-1:0] b,
		output wire [BUS_WIDTH-1:0] q
);

	assign q = (~s) ? a : b;

endmodule
