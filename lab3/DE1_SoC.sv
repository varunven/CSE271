// Top-level module that defines the I/Os for the DE-1 SoC board
	
	module DE1_SoC (SW, LEDR);
	output logic  [9:0] LEDR;
	input  logic  [9:0] SW;
	

	// Logic to map the inputs for SW[9], SW[8], SW[7], SW[0] for U, P, C, Mark respectively
	// Result should drive LEDR[0] for Discount, LEDR[1] for Expensive, LEDR[2] for Stolen. 
	assign LEDR[0] = (SW[9] && SW[7]) || SW[8];
	assign LEDR[1] = ((!SW[8] && !SW[7]) || (!SW[8] && SW[9])) && !SW[0];
	assign LEDR[2] = !(!SW[9] + SW[8] + SW[7]) || !(SW[7] + SW[8] + SW[0]);

	endmodule

   module DE1_SoC_testbench(); 
	logic  [1:0] LEDR;
	logic  [9:0] SW;
	DE1_SoC dut (.SW(SW), .LEDR(LEDR));  
   // Try all combinations of inputs.
	integer   i; 
	initial begin    
		for(i = 0; i <16; i++) begin  
			{SW[9], SW[8], SW[7], SW[0]} = i; #10;     
		end    
	end  
endmodule