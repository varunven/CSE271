// Top-level module that defines the I/Os for the DE-1 SoC board
	
	module originalupc (SW, LEDR);
	output logic  [9:0] LEDR;
	input  logic  [9:0] SW;
	

	// Logic to map the inputs for SW[9], SW[8], SW[7], SW[0] for U, P, C, Mark respectively
	// Result should drive LEDR[0] for Discount, LEDR[1] for Expensive, LEDR[2] for Stolen. 
	assign LEDR[0] = (SW[9] && SW[7]) || SW[8];
	assign LEDR[1] = (SW[8] & SW[0]) || (!SW[8] && !SW[7] && !SW[0]) || (SW[9] && !SW[8] && !SW[0]);

	endmodule