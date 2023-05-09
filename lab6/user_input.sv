module userInput (Clock, Reset, in, out);

	input logic Clock, Reset;
	input logic in;
	output logic out; 

	
	enum {pressed, not_pressed} ps, ns;

	// Next State logic
	always_comb begin
		case (ps)
			pressed: 	if (in) 		ns = pressed; 
							else 			ns = not_pressed;
			not_pressed: 	if (in) 		ns = pressed; 
								else 			ns = not_pressed; 

		endcase
		
		if (ps == pressed & ns == not_pressed) begin out = 1;end
		else begin out = 0; end		
	end


	// DFFs
	always_ff @(posedge Clock) begin
		if (Reset)
			ps <= not_pressed;
		else
			ps <= ns;
	end
endmodule 

module userInput_testbench();
	logic clk;
	logic [3:0] KEY; 
	logic out;
	logic [9:0] SW;
	

	userInput testUserInput (.Clock(clk), .Reset(SW[9]), .in(KEY[3]), .out(out));

	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
																	
		SW[9] <= 1; 										@(posedge clk);
		SW[9] <= 0;											@(posedge clk);
		KEY[3] <=0;											@(posedge clk);
		KEY[3] <=1;											@(posedge clk);
		repeat(2)		

		 $stop; // End the simulation.
	end
endmodule
