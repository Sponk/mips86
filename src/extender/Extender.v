/**
 * The SignExtender takes a small input and extends it to a bigger output.
 * This is useful for converting 16bit signed integers to 32bit signed
 * integers for example.
 *
 * This module has two operation modes: signExtend = 0 causes it to fill up
 * with 0 without caring for the sign bit. This operation changes the value of
 * negative numbers.
 *
 * signExtend = 1 fills up the integer with the value of the sign bit. This
 * operation does not change the value of the number.
 */
module SignExtender #(parameter INPUT_WIDTH = 16, parameter OUTPUT_WIDTH = 32)
		(
			input wire [INPUT_WIDTH-1:0] in,
			input wire signExtend,
			output wire [OUTPUT_WIDTH-1:0] out
		);

	assign out[INPUT_WIDTH-1:0] = in;

	genvar i;
	generate
		for(i = INPUT_WIDTH; i < OUTPUT_WIDTH; i = i + 1)
		begin : extender
			assign out[i] = (signExtend) ? in[INPUT_WIDTH-1] : 0;
		end
	endgenerate
endmodule
