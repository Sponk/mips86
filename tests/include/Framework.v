task display_test(input integer expected, input integer actual);

	if(expected !== actual)
		$display("%m: TEST FAILED!", actual, expected);
	else
		$display("%m: Test passed!", actual, expected);
endtask

task display_test_bin(input integer expected, input integer actual);

	if(expected !== actual)
		$display("%m: TEST FAILED! actual = %b expected = %b", actual, expected);
	else
		$display("%m: Test passed! actual = %b", actual);
endtask

task test_nequal_hex(input integer expected, input integer actual);
	if(expected == actual)
		$display("%m: TEST FAILED! %h %h", actual, expected);
	else
		$display("%m: Test passed! %h", actual);

endtask

/*task display_test_float(input wire [31:0]  expected, input wire [31:0] actual);

	if(expected !== actual)
		$display("%m: TEST FAILED! %f %f", actual, expected);
	else
		$display("%m: Test passed! %f %f", actual, expected);
endtask*/
