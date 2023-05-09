module comparator (out, clk, a, b);

	output logic out;
	
	input logic clk;
	input logic [8:0] a;
	input logic [9:0] b;
	
	logic [9:0] adjusteda;
	
	always_comb begin
				
		for(int i=9; i>=1; i=i-1) begin
			adjusteda[i] = a[i-1];
		end
		adjusteda[0] = 1'b0;
		out = (adjusteda[9:0] > b[9:0]);
	end	
endmodule 

module comparator_testbench();
	logic clk;
	logic [9:0] SW;
	logic [9:0] comp;
	logic compare;
	
	
	comparator dut (.out(compare), .clk(clk), .SW(SW[8:0]), .comp(comp));

	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
		
		SW = 01110101;comp = 1111101010;	@(posedge clk);		
		SW = 01010101;comp = 1111100010;	@(posedge clk);			
		SW = 01110101;comp = 1111101010;	@(posedge clk);			
		SW = 01110001;comp = 1111010100;	@(posedge clk);			
		SW = 01110101;comp = 1111101010;	@(posedge clk);		
		SW = 11110101;comp = 0111101010;	@(posedge clk);		
		 
		$stop; // End the simulation.
	end
endmodule