module winner (Clock, Reset, L, R, led9, led1, HEX0, HEX1, finalWin);

	input logic Clock, Reset;

	// L is true when left key is pressed, R is true when the right key
	// is pressed, led9 is true when LED9 is on, and led1
	// is true when LED1 is on.
	input logic L, R, led9, led1;

	output logic [6:0] HEX0, HEX1;
	output logic finalWin;
	
	logic p1won, p2won;
	
	enum {ongoing, p1w, p2w} ps, ns;

	always_comb begin
		case (ps)
			ongoing:
				if (led9 & L & ~R) ns = p2w;
				else if (led1 & ~L & R) ns = p1w;
				else ns = ongoing;
			p1w:
				ns = ongoing;
			p2w:
				ns = ongoing;
		endcase	
		if(ps == p1w) begin p1won = 1; p2won = 0; finalWin = 1; end
		else if(ps == p2w) begin p1won = 0; p2won = 1; finalWin = 1; end
		else begin p1won = 0; p2won = 0; finalWin = 0; end
	end

	score score1(.Clock(Clock), .Reset(Reset), .win(p1won), .hex(HEX0));
	score score2(.Clock(Clock), .Reset(Reset), .win(p2won), .hex(HEX1));

	always_ff @(posedge Clock) begin
		if (Reset)
		begin
			ps <= ongoing;
		end
		else
			ps <= ns;
	end
endmodule

module winner_testbench();
	logic clk;
	logic [3:0] KEY; 
	logic [9:0] SW;
	logic [9:0] LEDR;
	logic [6:0] HEX0;
	

	winner dut (.Clock(clk), .Reset(SW[9]), .L(KEY[3]), .R(KEY[0]), .led9(LEDR[9]), .led1(LEDR[1]), .HEX0(HEX0));

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
		KEY[3]<=0; KEY[0]<= 0; LEDR[9]<=0; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 0; LEDR[9]<=0; LEDR[1]<=1; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 0; LEDR[9]<=1; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 0; LEDR[9]<=1; LEDR[1]<=1; @(posedge clk);	

		KEY[3]<=0; KEY[0]<= 1; LEDR[9]<=0; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 1; LEDR[9]<=0; LEDR[1]<=1; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 1; LEDR[9]<=1; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 1; LEDR[9]<=1; LEDR[1]<=1; @(posedge clk);
		
		KEY[3]<=1; KEY[0]<= 0; LEDR[9]<=0; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 0; LEDR[9]<=0; LEDR[1]<=1; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 0; LEDR[9]<=1; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 0; LEDR[9]<=1; LEDR[1]<=1; @(posedge clk);
		
		KEY[3]<=1; KEY[0]<= 1; LEDR[9]<=0; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 1; LEDR[9]<=0; LEDR[1]<=1; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 1; LEDR[9]<=1; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 1; LEDR[9]<=1; LEDR[1]<=1; @(posedge clk);
		//reset = 1
		SW[9] <= 1;
		KEY[3]<=0; KEY[0]<= 0; LEDR[9]<=0; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 0; LEDR[9]<=0; LEDR[1]<=1; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 0; LEDR[9]<=1; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 0; LEDR[9]<=1; LEDR[1]<=1; @(posedge clk);	

		KEY[3]<=0; KEY[0]<= 1; LEDR[9]<=0; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 1; LEDR[9]<=0; LEDR[1]<=1; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 1; LEDR[9]<=1; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=0; KEY[0]<= 1; LEDR[9]<=1; LEDR[1]<=1; @(posedge clk);
		
		KEY[3]<=1; KEY[0]<= 0; LEDR[9]<=0; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 0; LEDR[9]<=0; LEDR[1]<=1; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 0; LEDR[9]<=1; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 0; LEDR[9]<=1; LEDR[1]<=1; @(posedge clk);
		
		KEY[3]<=1; KEY[0]<= 1; LEDR[9]<=0; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 1; LEDR[9]<=0; LEDR[1]<=1; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 1; LEDR[9]<=1; LEDR[1]<=0; @(posedge clk);
		KEY[3]<=1; KEY[0]<= 1; LEDR[9]<=1; LEDR[1]<=1; @(posedge clk);
		repeat(2) @(posedge clk);
		
		$stop; // End the simulation.
	end
endmodule
