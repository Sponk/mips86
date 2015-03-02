
module SignExtendTest;

	`include "Framework.v"

	reg [15:0] in;
	reg signExtend;
	wire [31:0] out;

	SignExtender se(in, signExtend, out);

	initial begin
		signExtend = 1;
		in = 15;
		#10 display_test(15, out);

		in = -12;
		#10 display_test(-12, out);

		in = 32;
		#10 display_test(32, out);
	
		in = -512;
		#10 display_test(-512, out);
		
		signExtend = 0;
		in = -5;
		#10 display_test(32'b00000000000000001111111111111011, out);		

		$finish;
	end

endmodule
