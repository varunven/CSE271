module columns (Clock, Reset, KEY, LEDR, Input, sum, fullRound); 
   input logic Clock, Reset, KEY, Input;
	output logic [7:0] LEDR; 
	output signed [3:0] sum;
	output logic fullRound;
	
	//points totalled per each row
	logic [3:0] p7, p6, p5, p4, p3, p2, p1, p0;
	logic fullRound0, fullRound1, fullRound2, fullRound3, fullRound4, fullRound5, fullRound6, fullRound7;
	
	combine_score combine(sum, p7, p6, p5, p4, p3, p2, p1, p0);	
	
	//row7
	ledbottom5 row7(.Clock(Clock), .Reset(Reset), .userinput(KEY), .LD(Input), .lightOn(LEDR[7]), .points(p7), .fullRound(fullRound7)); 
	//row6
	ledbottom5 row6(.Clock(Clock), .Reset(Reset), .userinput(KEY), .LD(LEDR[7]), .lightOn(LEDR[6]), .points(p6), .fullRound(fullRound6)); 
	//row5
	ledbottom5 row5(.Clock(Clock), .Reset(Reset), .userinput(KEY), .LD(LEDR[6]), .lightOn(LEDR[5]), .points(p5), .fullRound(fullRound5)); 
	//row4
	ledbottom5 row4(.Clock(Clock), .Reset(Reset), .userinput(KEY), .LD(LEDR[5]), .lightOn(LEDR[4]), .points(p4), .fullRound(fullRound4)); 
	//row3
	ledbottom5 row3(.Clock(Clock), .Reset(Reset), .userinput(KEY), .LD(LEDR[4]), .lightOn(LEDR[3]), .points(p3), .fullRound(fullRound3)); 
	//row2
	led2 row2(.Clock(Clock), .Reset(Reset), .userinput(KEY), .LD(LEDR[3]), .lightOn(LEDR[2]), .points(p2), .fullRound(fullRound2)); 
	//row1
	led1 row1(.Clock(Clock), .Reset(Reset), .userinput(KEY), .LD(LEDR[2]), .lightOn(LEDR[1]), .points(p1), .fullRound(fullRound1)); 
	//row0	
	led0 row0(.Clock(Clock), .Reset(Reset), .userinput(KEY), .LD(LEDR[1]), .lightOn(LEDR[0]), .points(p0), .fullRound(fullRound0));
	
	always_comb begin
		fullRound<=(fullRound0|fullRound1|fullRound2|fullRound3|fullRound4|fullRound5|fullRound6|fullRound7);
	end
	
endmodule

module columns_testbench();
	logic clk, Reset;
	logic [9:0] LEDR;
	logic [9:0] SW;
	logic Input, mykey;
	logic [3:0] sum;
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	columns dut (clk, SW[9], mykey, LEDR, Input, sum); 
	
	initial begin
		SW[9] <= 1; 	repeat(2)@(posedge clk);
		SW[9] <= 0;		repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 1; repeat(2)@(posedge clk);
		Input <= 1; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 0; repeat(2)@(posedge clk);
		mykey <= 1; repeat(2)@(posedge clk);
		$stop;	
	end
endmodule