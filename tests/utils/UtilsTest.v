
module UtilsTest;

	`include "Framework.v"

	reg muxA;
	reg muxB;
	reg muxS;
	wire muxQ;

	Mux2x1 mux(muxS, muxA, muxB, muxQ);

	reg [31:0] wmuxA;
	reg [31:0] wmuxB;
	wire [31:0] wmuxQ;

	WideMux2x1 wmux(muxS, wmuxA, wmuxB, wmuxQ);

	initial begin
		muxA = 1;
		muxB = 0;
		muxS = 0;

		#10 display_test(1, muxQ);
		
		muxA = 0;
		#10 display_test(0, muxQ);

		muxB = 1;
		muxS = 1;
		#10 display_test(1, muxQ);	

		wmuxA = 32'hDEADBEEF;
		wmuxB = 32'hCAFEBABE;

		muxS = 0;
		#10 display_test(32'hDEADBEEF, wmuxQ);
		
		muxS = 1;
		#10 display_test(32'hCAFEBABE, wmuxQ);
	end

endmodule
