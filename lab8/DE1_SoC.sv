module DE1_SoC (CLOCK_50, GPIO_1, KEY, SW, HEX0, HEX1, HEX2, HEX3); 
   input logic CLOCK_50; // 50MHz clock.
	output logic [35:0] GPIO_1;
	input logic [3:0] KEY; // True when not pressed, False when pressed 
	input logic [9:0] SW;
	output logic [6:0] HEX0, HEX1, HEX2, HEX3;
	
	logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
   logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
	logic [7:0] col1, col2, col3, col4;
	
	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic reset;
	logic [31:0] div_clk;
	parameter whichClock = 20;
	assign reset = SW[9];
	
	//USER KEY AND CPU LOGIC
	logic key1, key2, key3, key4;
	logic cpuai1, cpuai2, cpuai3, cpuai4;
	logic key1stable, key2stable, key3stable, key4stable; 
	logic cpuaistable1, cpuaistable2, cpuaistable3, cpuaistable4;
	logic [7:0] lfsrq1, lfsrq2, lfsrq3, lfsrq4;
	logic [27:0] lfsrq12;
	
	clock_divider cdiv (.clock(CLOCK_50), .reset(reset), .divided_clocks(div_clk)); 
	
	//  Clock  selection;  allows  for  easy  switching  between  simulation  and  board  clocks
	logic clkSelect;
   assign clkSelect = CLOCK_50; //for simulation
	//assign clkSelect = div_clk[whichClock]; //for board programming
	//need to update this so it adjusts speed to not be 15 but to do it via switches
	//go to OH so TAs can help build counter like maxim said
	LEDDriver Driver (.CLK(clkSelect), .RST(reset), .EnableCount(1'b1), .RedPixels(RedPixels), .GrnPixels(GrnPixels), .GPIO_1(GPIO_1), .SW(SW));
	
	Row2Green row2green(reset, GrnPixels);
		
	//Puts keys 3 thru 0 thru the dff to avoid metastability
	double_dff dff1(.q(key1stable), .d(~KEY[0]), .reset(reset), .clk(clkSelect));
	double_dff dff2(.q(key2stable), .d(~KEY[1]), .reset(reset), .clk(clkSelect));
	double_dff dff3(.q(key3stable), .d(~KEY[2]), .reset(reset), .clk(clkSelect));
	double_dff dff4(.q(key4stable), .d(~KEY[3]), .reset(reset), .clk(clkSelect));

	//passes in user input from keys and cpu input and outputs pressed or not
	userInput key1i(.Clock(clkSelect), .Reset(reset), .in(key1stable), .out(key1));
	userInput key2i(.Clock(clkSelect), .Reset(reset), .in(key2stable), .out(key2));
	userInput key3i(.Clock(clkSelect), .Reset(reset), .in(key3stable), .out(key3));
	userInput key4i(.Clock(clkSelect), .Reset(reset), .in(key4stable), .out(key4));

	userInput aii1(.Clock(clkSelect), .Reset(reset), .in(cpuaistable1), .out(cpuai1));
	userInput aii2(.Clock(clkSelect), .Reset(reset), .in(cpuaistable2), .out(cpuai2));
	userInput aii3(.Clock(clkSelect), .Reset(reset), .in(cpuaistable3), .out(cpuai3));
	userInput aii4(.Clock(clkSelect), .Reset(reset), .in(cpuaistable4), .out(cpuai4));

	//uses lfsr and comparator to generate random values for lights
	LFSR1 lfsr1(.q(lfsrq1), .reset(reset), .clk(clkSelect));
	LFSR1 lfsr2(.q(lfsrq2), .reset(reset), .clk(clkSelect));
	LFSR1 lfsr3(.q(lfsrq3), .reset(reset), .clk(clkSelect));
	LFSR1 lfsr4(.q(lfsrq4), .reset(reset), .clk(clkSelect));
	
	LFSR2 lfsr21(.q(lfsrq12), .reset(reset), .clk(clkSelect));
	
	comparator1 compare1(.out(cpuaistable1), .clk(clkSelect), .a(lfsrq12[6:0]), .b(lfsrq1));
	comparator1 compare2(.out(cpuaistable2), .clk(clkSelect), .a(lfsrq12[13:7]), .b(lfsrq2));
	comparator1 compare3(.out(cpuaistable3), .clk(clkSelect), .a(lfsrq12[20:14]), .b(lfsrq3));
	comparator1 compare4(.out(cpuaistable4), .clk(clkSelect), .a(lfsrq12[27:21]), .b(lfsrq4));

	//sum nums
	logic [3:0] sum1, sum2, sum3, sum4;
	logic [3:0] tsum1, tsum2, tsum3, tsum4;
	logic [3:0] tsum1f, tsum2f, tsum3f, tsum4f;	
	logic fullRound1, fullRound2, fullRound3, fullRound4;
	
	//col1
	columns c1 (.Clock(clkSelect), .Reset(reset), .KEY(key1), .LEDR(col1), .Input(cpuai1), .sum(sum1), .fullRound(fullRound1)); 
	//col2
	columns c2 (.Clock(clkSelect), .Reset(reset), .KEY(key2), .LEDR(col2), .Input(cpuai2), .sum(sum2), .fullRound(fullRound2)); 
	//col3
	columns c3 (.Clock(clkSelect), .Reset(reset), .KEY(key3), .LEDR(col3), .Input(cpuai3), .sum(sum3), .fullRound(fullRound3)); 
	//col4
	columns c4 (.Clock(clkSelect), .Reset(reset), .KEY(key4), .LEDR(col4), .Input(cpuai4), .sum(sum4), .fullRound(fullRound4)); 
		
	//use output of col to assign red pixels to
	always_ff @(posedge clkSelect) begin
		for(int i=0; i<8; i++) begin
			RedPixels[i][00] = col1[i];
			RedPixels[i][05] = col2[i];
			RedPixels[i][10] = col3[i];
			RedPixels[i][15] = col4[i];
		end
	end
	
	always_ff @(posedge clkSelect) begin
		if (reset) begin tsum1<=0; tsum2<=0; tsum3<=0; tsum4<=0; end
		else begin
			if(fullRound1) begin tsum1<=tsum1+sum1; end 
			else begin tsum1<=tsum1+sum1-sum1; end
			if(fullRound2) begin tsum2<=tsum2+sum2; end 
			else begin tsum2<=tsum2+sum2-sum2; end
			if(fullRound3) begin tsum3<=tsum3+sum3; end 
			else begin tsum3<=tsum3+sum3-sum3; end
			if(fullRound4) begin tsum4<=tsum4+sum4; end 
			else begin tsum4<=tsum4+sum4-sum4; end
		end
	end
	
	always_ff @(posedge clkSelect) begin
		if(tsum1<0) begin tsum1f<=0; end
		else begin tsum1f<=tsum1; end
		if(tsum2<0) begin tsum2f<=0; end
		else begin tsum2f<=tsum2; end
		if(tsum3<0) begin tsum3f<=0; end
		else begin tsum3f<=tsum3; end
		if(tsum4<0) begin tsum4f<=0; end
		else begin tsum4f<=tsum4; end
	end
	
	displayScore score(.Clock(clkSelect), .Reset(reset), .sum(tsum1f%10), .hex(HEX0)); 
	displayScore score2(.Clock(clkSelect), .Reset(reset), .sum(tsum2f%10), .hex(HEX1)); 
	displayScore score3(.Clock(clkSelect), .Reset(reset), .sum(tsum3f%10), .hex(HEX2)); 
	displayScore score4(.Clock(clkSelect), .Reset(reset), .sum(tsum4f%10), .hex(HEX3)); 

endmodule


module DE1_SoC_testbench();
	logic clk;
	logic [3:0] KEY; 
	logic [9:0] SW;
	logic [6:0] HEX0, HEX1;
	logic [35:0] GPIO_1;
	
	DE1_SoC dut (.CLOCK_50(clk), .KEY(KEY), .SW(SW), .HEX0(HEX0), .HEX1(HEX1), .GPIO_1(GPIO_1));
	
	// Set up the clock.
	parameter CLOCK_PERIOD=1000;
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

		KEY[1] <= 1;		repeat(2)@(posedge clk);
		KEY[1] <= 0;		repeat(2)@(posedge clk);
		KEY[1] <= 1;		repeat(2)@(posedge clk);
		KEY[1] <= 0;		repeat(2)@(posedge clk);
		KEY[1] <= 1;		repeat(2)@(posedge clk);
		KEY[1] <= 0;		repeat(2)@(posedge clk);
		KEY[1] <= 1;		repeat(2)@(posedge clk);
		KEY[1] <= 0;		repeat(2)@(posedge clk);
		KEY[1] <= 1;		repeat(2)@(posedge clk);
		
		KEY[2] <= 1;		repeat(2)@(posedge clk);
		KEY[2] <= 0;		repeat(2)@(posedge clk);
		KEY[2] <= 1;		repeat(2)@(posedge clk);
		KEY[2] <= 0;		repeat(2)@(posedge clk);
		KEY[2] <= 1;		repeat(2)@(posedge clk);
		KEY[2] <= 0;		repeat(2)@(posedge clk);
		KEY[2] <= 1;		repeat(2)@(posedge clk);
		KEY[2] <= 0;		repeat(2)@(posedge clk);
		KEY[2] <= 1;		repeat(2)@(posedge clk);
		
		KEY[3] <= 1;		repeat(2)@(posedge clk);
		KEY[3] <= 0;		repeat(2)@(posedge clk);
		KEY[3] <= 1;		repeat(2)@(posedge clk);
		KEY[3] <= 0;		repeat(2)@(posedge clk);
		KEY[3] <= 1;		repeat(2)@(posedge clk);
		KEY[3] <= 0;		repeat(2)@(posedge clk);
		KEY[3] <= 1;		repeat(2)@(posedge clk);
		KEY[3] <= 0;		repeat(2)@(posedge clk);
		KEY[3] <= 1;		repeat(2)@(posedge clk);

		SW[9] <= 1; 	repeat(2)@(posedge clk);
		SW[9] <= 0;		repeat(2)@(posedge clk);

		KEY[0] <= 0;		repeat(200)@(posedge clk);
		KEY[0] <= 1;		repeat(2)@(posedge clk);
		KEY[1] <= 0;		repeat(200)@(posedge clk);
		KEY[1] <= 1;		repeat(2)@(posedge clk);
		KEY[2] <= 0;		repeat(200)@(posedge clk);
		KEY[2] <= 1;		repeat(2)@(posedge clk);
		KEY[3] <= 0;		repeat(200)@(posedge clk);
		KEY[3] <= 1;		repeat(2)@(posedge clk);
		
		$stop; // End the simulation.
	end
endmodule 
