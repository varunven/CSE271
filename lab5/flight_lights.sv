
module flight_lights (clk, reset, out, SW, LEDR);  
    input logic  clk, reset;
	 input logic [9:0] SW;
	 output logic out;  
	 output logic [2:0] LEDR;
	 // State variables 
	 enum { ohohone, ohoneoh, oneohoh, oneohone } ps, ns;
	 // Next State logic 
    always_comb   
	 begin     
	 case (ps)
			//00
			ohohone: 
			if(!SW[0] & !SW[1]) begin LEDR[2] = 0; LEDR[1] = 0; LEDR[0] = 1; ns = oneohone; end
			else if(SW[0] & !SW[1]) begin LEDR[2] = 0; LEDR[1] = 0; LEDR[0] = 1; ns = ohoneoh; end
			else begin LEDR[2] = 0; LEDR[1] = 0; LEDR[0] = 1; ns = oneohoh; end
			//01
			ohoneoh:
			if(!SW[0] & !SW[1]) begin LEDR[2] = 0; LEDR[1] = 1; LEDR[0] = 0; ns = oneohone; end
			else if(SW[0] & !SW[1]) begin LEDR[2] = 0; LEDR[1] = 1; LEDR[0] = 0; ns = oneohoh; end
			else begin LEDR[2] = 0; LEDR[1] = 1; LEDR[0] = 0; ns = ohohone; end
			//10
			oneohoh: 
			if(!SW[0] & !SW[1]) begin LEDR[2] = 1; LEDR[1] = 0; LEDR[0] = 0; ns = oneohone; end
			else if(SW[0] & !SW[1]) begin LEDR[2] = 1; LEDR[1] = 0; LEDR[0] = 0; ns = ohohone; end
			else begin LEDR[2] = 1; LEDR[1] = 0; LEDR[0] = 0; ns = ohoneoh; end
			//11
			oneohone:  
			if(!SW[0] & !SW[1]) begin LEDR[2] = 1; LEDR[1] = 0; LEDR[0] = 1; ns = ohoneoh; end
			else begin LEDR[2] = 1; LEDR[1] = 0; LEDR[0] = 1; ns = ohoneoh; end
 	 endcase  
	 end      // Output logic - could also be another always_comb block.
	 always_comb
	 begin
		out = ((SW[1] & !(ps == ohoneoh || ps == oneohone))
		|| (SW[0] & !(ps == ohoneoh || ps == oneohone))
		|| (!(ps == oneohoh || ps == oneohone) & (ps == ohoneoh || ps == oneohone))
		|| (!SW[1] & !SW[0] & (ps == ohoneoh || ps == oneohone))); 
	 end 
	 //   DFFs   
	 always_ff @(posedge clk) begin
		if(reset)
			ps <= oneohone;
			
		else
			ps <= ns;
	 end
endmodule

module flight_lights_testbench();
     logic  clk, reset, w;
	  logic  out;
	  flight_lights dut (clk, reset, w, out);
	  // Set up a simulated clock.
	  parameter   CLOCK_PERIOD=100; 
	  initial   begin 
			clk <= 0;
			forever #(CLOCK_PERIOD/2) clk <= ~clk;     //   Forever   toggle   the   clock
		end      
		// Set up the inputs to the design.  Each line is a clock cycle. 
      initial   begin
			@(posedge clk);
			reset <= 1;         @(posedge clk); // Always reset FSMs at start 
			reset <= 0; w <= 0; @(posedge clk);      
			@(posedge clk);                        
			@(posedge clk);                     
			@(posedge clk);                    
			w <= 1; @(posedge clk);
			w <= 0; @(posedge clk);
			w <= 1; @(posedge clk); 
			@(posedge clk);       
			@(posedge clk);      
			@(posedge clk);     
			w <= 0; @(posedge clk);
			@(posedge clk);  
			$stop; // End the simulation.
		end 
endmodule  