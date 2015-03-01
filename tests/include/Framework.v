task display_test(input integer expected, input integer actual);

if(expected !== actual)
	$display("%m: TEST FAILED!", actual, expected);
else
	$display("%m: Test passed!", actual, expected);
endtask
