module AluTest;

reg [7:0] a = 0;
reg [7:0] b = 0;
reg [3:0] control = 0;

wire [7:0] out;
wire overflow;

reg clk;
reg reset;

ArithmeticLogicUnit alu(a, b, control, clk, reset, out, overflow);

`include "Framework.v"

always #10 clk = ~clk;

initial begin

	clk = 0;	
	reset = 1;
	#20 reset = 0;
	
	a = 5;
	b = 7;

	control = 0;
	
	#10 display_test(12, out);
	// #10 $display("AluTest: Sent %d %d, expecting %d, actual %d", a, b, 12, out);

	// Substraction
	a = 5;
	b = 7;

	control = 1;

	#10 display_test(-2, $signed(out));
	//#10 $display("AluTest: Sent %d %d, expecting %d, actual %d", a, b, -2, $signed(out));

	// Shifting test
	a = 5;
	b = 1;

	control = 2;

	#10 display_test(10, out);
	//#10 $display("AluTest: Sent %d %d, expecting %d, actual %d", a, b, 10, out);

	// Bitwise OR test
	a = 'b01010101;
	b = 'b10101010;	

	control = 3;

	#10 display_test('b11111111, out);
	// #10 $display("AluTest: Sent %b %b, expecting %b, actual %b", a, b, 'b1111111, out);
	// Bitwise AND test
	a = 'b01010101;
	b = 'b10101010;	

	control = 4;

	#10 display_test(0, out);
	//#10 $display("AluTest: Sent %b %b, expecting %b, actual %b", a, b, 'b00000000, out);

	// Bitwise XOR test
	a = 'b01010101;
	b = 'b10101011;	

	control = 5;

	#10 display_test('b11111110, out);
	// #10 $display("AluTest: Sent %b %b, expecting %b, actual %b", a, b, 'b11111110, out);

	// Bitwise ROR test
	a = 'b01010101;
	b = 1;	

	control = 6;

	#10 display_test('b10101010, out);
	//#10 $display("AluTest: Sent %b %b, expecting %b, actual %b", a, b, 'b10101010, out);

	// EQUALS test
	a = 'b01010101;
	b = 'b01010101;	

	control = 7;

	#10 display_test(1, overflow);
	//#10 $display("AluTest: Sent %d %d, expecting %d, actual %d", a, b, 1, overflow);


	// IS_GREATER test
	a = 5;
	b = 1;	

	control = 8;

	#10 display_test(1, overflow);
	// #10 $display("AluTest: Sent %d %d, expecting %d, actual %d", a, b, 1, overflow);


	// IS_SMALLER test
	a = 5;
	b = 1;	

	control = 9;

	#10 display_test(0, overflow);
	//#10 $display("AluTest: Sent %d %d, expecting %d, actual %d", a, b, 0, overflow);

	$finish;
end

endmodule
