module DE1_SoC (CLOCK_50, KEY, LEDR, SW, HEX0, HEX1); 
   input logic CLOCK_50; // 50MHz clock.
	output logic [9:1] LEDR; 
	input logic [3:0] KEY; // True when not pressed, False when pressed 
	input logic [9:0] SW;
	output logic [6:0] HEX0, HEX1;
	
	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic reset, win;
	logic [31:0] div_clk;
	parameter whichClock = 25;
	assign reset = SW[9];
	
	//CPU LOGIC
	logic key0, cpuai, key0stable, cpuaistable;
	logic [9:0] lfsrq;
	//logic key0, key3, cpuai, key0stable, key3stable;
	
	clock_divider cdiv (.clock(CLOCK_50), .reset(reset), .divided_clocks(div_clk)); 
	
	//  Clock  selection;  allows  for  easy  switching  between  simulation  and  board  clocks
	logic clkSelect;
   assign clkSelect = CLOCK_50; //for simulation
	//assign clkSelect = div_clk[whichClock]; //for board programming

	//Puts keys 3 and 0 thru the dff to avoid metastability
	double_dff dff1(.q(key0stable), .d(~KEY[0]), .reset(reset), .clk(clkSelect));
	double_dff dff2(.q(key3stable), .d(~KEY[3]), .reset(reset), .clk(clkSelect));

	userInput key0i(.Clock(clkSelect), .Reset(reset), .in(key0stable), .out(key0));
	//userInput key3i(.Clock(clkSelect), .Reset(reset), .in(key3stable), .out(key3));
	//assign cpuai = key3;
	
	//COMMENTING CPUAI STUFF
	userInput ai(.Clock(clkSelect), .Reset(reset), .in(cpuaistable), .out(cpuai));
   
	LFSR lfsr(.q(lfsrq), .reset(reset), .clk(clkSelect));
	comparator compare(.out(cpuaistable), .clk(clkSelect), .a(SW[8:0]), .b(lfsrq));
	
	//led1
	normalLight led1 (.Clock(clkSelect), .Reset(reset), .L(cpuai), .R(key0), .NL(LEDR[2]),
	.NR(1'b0), .lightOn(LEDR[1]));
	//led2
	normalLight led2 (.Clock(clkSelect), .Reset(reset), .L(cpuai), .R(key0), .NL(LEDR[3]),
	.NR(LEDR[1]), .lightOn(LEDR[2]));
	//led3
	normalLight led3 (.Clock(clkSelect), .Reset(reset), .L(cpuai), .R(key0), .NL(LEDR[4]),
	.NR(LEDR[2]), .lightOn(LEDR[3]));
	//led4
	normalLight led4 (.Clock(clkSelect), .Reset(reset), .L(cpuai), .R(key0), .NL(LEDR[5]),
	.NR(LEDR[3]), .lightOn(LEDR[4]));
	
	//led5 CENTER
	centerLight led5 (.Clock(clkSelect), .Reset(reset), .L(cpuai), .R(key0), .NL(LEDR[6]),
	.NR(LEDR[4]), .lightOn(LEDR[5]), .win(win));
	
	//led6
	normalLight led6 (.Clock(clkSelect), .Reset(reset), .L(cpuai), .R(key0), .NL(LEDR[7]),
	.NR(LEDR[5]), .lightOn(LEDR[6]));
	//led7
	normalLight led7 (.Clock(clkSelect), .Reset(reset), .L(cpuai), .R(key0), .NL(LEDR[8]),
	.NR(LEDR[6]), .lightOn(LEDR[7]));
	//led8
	normalLight led8 (.Clock(clkSelect), .Reset(reset), .L(cpuai), .R(key0), .NL(LEDR[9]),
	.NR(LEDR[7]), .lightOn(LEDR[8]));
	//led9
	normalLight led9 (.Clock(clkSelect), .Reset(reset), .L(cpuai), .R(key0), .NL(1'b0),
	.NR(LEDR[8]), .lightOn(LEDR[9]));
	
	winner victor (.Clock(clkSelect), .Reset(reset), .L(cpuai), .R(key0), .led9(LEDR[9]),
	.led1(LEDR[1]), .HEX0(HEX0), .HEX1(HEX1), .finalWin(win));	 
endmodule

module DE1_SoC_testbench();
	logic clk;
	logic [3:0] KEY; 
	logic [9:0] SW;
	logic [9:1] LEDR;
	logic [6:0] HEX0, HEX1;
	
	DE1_SoC dut (.CLOCK_50(clk), .KEY(KEY), .LEDR(LEDR), .SW(SW), .HEX0(HEX0), .HEX1(HEX1));
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin													
		SW[9] <= 1; 	repeat(2)@(posedge clk);
		SW[9] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[0] <= 0;		repeat(2)@(posedge clk);
		$stop; // End the simulation.
	end
endmodule 
