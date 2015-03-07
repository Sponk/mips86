
module SimpleDataflowTest;

	initial begin
		$dumpfile("timing.vcd");
	end

	reg reset = 0;
	reg clk = 0;

	always #10 clk = ~clk;

	SimpleDataflow ddf(clk, reset);

	initial begin
		$dumpvars(0,ddf);

		reset = 1;
		#20 reset = 0;
	
		#3000000 $finish;
	end

endmodule
