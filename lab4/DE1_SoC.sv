// Top-level module that defines the I/Os for the DE-1 SoC board
	
	module DE1_SoC (SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	output logic  [9:0] LEDR;
	input  logic  [9:0] SW;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [6:0] leds0, leds1, leds2, leds3, leds4, leds5;
	
	assign HEX0 = ~leds0;
	assign HEX1 = ~leds1;
	assign HEX2 = ~leds2;
	assign HEX3 = ~leds3;
	assign HEX4 = ~leds4;
	assign HEX5 = ~leds5;
//	seg7 s0(.bcd(SW[3:0]), .leds(leds0));
//	seg7 s1(.bcd(SW[7:4]), .leds(leds1));

	shopsegment s0(.upc(SW[9:7]), .HEX0(leds0), .HEX1(leds1), .HEX2(leds2), .HEX3(leds3), .HEX4(leds4), .HEX5(leds5));
	originalupc ou(.SW(SW), .LEDR(LEDR));
	
	endmodule

   module DE1_SoC_testbench(); 
	logic  [9:0] LEDR;
	logic  [9:0] SW;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	DE1_SoC dut (.SW(SW), .LEDR(LEDR), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5));  
   // Try all combinations of inputs.
	integer   i; 
	initial begin    
//		for(i = 0; i <16; i++) begin  
//			SW[3:0] = i; #10;
//		end   
//		for(i = 0; i <16; i++) begin  
//			SW[7:4] = i; #10;
//		end
		for(i = 0; i<16; i++) begin
			{SW[9], SW[8], SW[7], SW[0]} = i; #10;
		end
	end  
endmodule