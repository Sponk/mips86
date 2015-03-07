

module Display
		#(parameter CLOCK_DIVISOR = 800,
		  parameter CLK_BITS = 16)
		(
			input wire clk,
			input wire [15:0] data,
			
			output reg [6:0] segments,
			output wire [3:0] anodes
		);
				
		reg [3:0] multiplexState = 4'b0111;
		assign anodes = multiplexState;
		
		wire [3:0] display[0:3];
				
		assign display[3] = data[15:12];
		assign display[2] = data[11:8];
		assign display[1] = data[7:4];
		assign display[0] = data[3:0];
		
		reg [1:0] counter = 0;
		reg [CLK_BITS-1:0] clockDivisor = 0;
		
		always @(posedge clk)
		begin
			if(clockDivisor >= CLOCK_DIVISOR)
			begin
				counter = counter + 1;
				clockDivisor = 0;
			end
			else
				clockDivisor = clockDivisor + 1;
		
			case(counter)
				0: multiplexState <= 'b1110;
				1: multiplexState <= 'b1101;
				2: multiplexState <= 'b1011;
				3: multiplexState <= 'b0111;
			endcase
		
			case(display[counter])
				0: segments <= ~'b0111111;
				1: segments <= ~'b0000110;
				2: segments <= ~'b1011011;
				3: segments <= ~'b1001111;
				4: segments <= ~'b1100110;
				5: segments <= ~'b1101101;
				6: segments <= ~'b1111101;
				7: segments <= ~'b0000111;
				8: segments <= ~'b1111111;
				9: segments <= ~'b1101111;
				10: segments <= ~'b1110111;
				11: segments <= ~'b1111100;
				12: segments <= ~'b0111001;
				13: segments <= ~'b1011110;
				14: segments <= ~'b1111001;
				15: segments <= ~'b1110001;
			endcase
		end
endmodule
