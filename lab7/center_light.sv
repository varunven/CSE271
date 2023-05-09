module centerLight (Clock, Reset, L, R, NL, NR, lightOn, win);

	input logic Clock, Reset;

	// L is true when left key is pressed, R is true when the right key
	// is pressed, NL is true when the light on the left is on, and NR
	// is true when the light on the right is on.
	input logic L, R, NL, NR, win;

	// when lightOn is true, the normal light should be on.
	output logic lightOn;
	
	enum {on, off} ps, ns;

	always_comb begin
		case (ps)
			on: 	if (L & R & ~NL & ~NR) begin ns = on; lightOn = 1; end
					else if (~L & ~R & ~NL & ~NR) begin ns = on; lightOn = 1; end
					else begin ns = off; lightOn = 1; end
			off: 	if (~L & R & NL & ~NR) begin ns = on; lightOn = 0; end
					else if (L & ~R & ~NL & NR) begin ns = on; lightOn = 0; end
					else begin ns = off; lightOn = 0; end
		endcase		
	end

	always_ff @(posedge Clock) begin
		if (Reset | win)
			ps <= on;
		else
			ps <= ns;
	end
endmodule 

module centerLight_testbench();
	logic clk;
	logic [3:0] KEY; 
	logic [9:0] SW;
	logic [9:0] LEDR;
	

	centerLight dut (.Clock(clk), .Reset(SW[9]), .L(KEY[3]), .R(KEY[0]), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));

	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
																	
		SW[9] <= 1;	@(posedge clk);
		SW[9] <= 0; @(posedge clk);
		//order will be key3, key0, ledr6, ledr4
		//reset = 0
		KEY[3]<=0; KEY[0]<= 0; LEDR[6]<=0; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 0; LEDR[6]<=0; LEDR[4]<=1; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 0; LEDR[6]<=1; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 0; LEDR[6]<=1; LEDR[4]<=1; @(posedge clk);	

		KEY[3]<=0; KEY[0]<= 1; LEDR[6]<=0; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 1; LEDR[6]<=0; LEDR[4]<=1; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 1; LEDR[6]<=1; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 1; LEDR[6]<=1; LEDR[4]<=1; @(posedge clk);
		
		KEY[3]<=1; KEY[0]<= 0; LEDR[6]<=0; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 0; LEDR[6]<=0; LEDR[4]<=1; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 0; LEDR[6]<=1; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 0; LEDR[6]<=1; LEDR[4]<=1; @(posedge clk);
		
		KEY[3]<=1; KEY[0]<= 1; LEDR[6]<=0; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 1; LEDR[6]<=0; LEDR[4]<=1; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 1; LEDR[6]<=1; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 1; LEDR[6]<=1; LEDR[4]<=1; @(posedge clk);
		//reset = 1
		SW[9] <= 1;
		KEY[3]<=0; KEY[0]<= 0; LEDR[6]<=0; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 0; LEDR[6]<=0; LEDR[4]<=1; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 0; LEDR[6]<=1; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 0; LEDR[6]<=1; LEDR[4]<=1; @(posedge clk);	

		KEY[3]<=0; KEY[0]<= 1; LEDR[6]<=0; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 1; LEDR[6]<=0; LEDR[4]<=1; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 1; LEDR[6]<=1; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 1; LEDR[6]<=1; LEDR[4]<=1; @(posedge clk);
		
		KEY[3]<=1; KEY[0]<= 0; LEDR[6]<=0; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 0; LEDR[6]<=0; LEDR[4]<=1; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 0; LEDR[6]<=1; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 0; LEDR[6]<=1; LEDR[4]<=1; @(posedge clk);
		
		KEY[3]<=1; KEY[0]<= 1; LEDR[6]<=0; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 1; LEDR[6]<=0; LEDR[4]<=1; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 1; LEDR[6]<=1; LEDR[4]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 1; LEDR[6]<=1; LEDR[4]<=1; @(posedge clk);
		repeat(2) @(posedge clk);
		
		$stop; // End the simulation.
	end
endmodule