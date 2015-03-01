

module HalfAdder(input wire a, b,
		 output wire s, c);
	assign s = a ^ b;
	assign c = a & b;						
endmodule

module FullAdder(
			input wire a,
			input wire b,
			input wire cin,
						
			output wire s,
			output wire cout);
					
	wire sha, cha1, cha2;

	HalfAdder ha1(cin,a,sha,cha1);
	HalfAdder ha2(sha,b,s,cha2);

	assign cout = cha1 | cha2;

endmodule

module BitAdder
	#(parameter BUS_WIDTH = 8)
	(
		input wire [BUS_WIDTH-1:0] a,
		input wire [BUS_WIDTH-1:0] b,
		input wire substract,
    		output wire [BUS_WIDTH-1:0] out,
    		output wire carry
    	);
	 
	wire [BUS_WIDTH:0] c;

	assign c[0] = substract;
	assign carry = c[BUS_WIDTH];
	
	generate
	genvar i;
	for(i = 0; i < BUS_WIDTH; i = i + 1) 
		begin : RippleAdder
			FullAdder add(a[i], b[i], c[i], out[i], c[i+1]);
		end
	endgenerate
endmodule
