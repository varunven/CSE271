module my_dff (q, d, reset, clk);

	output logic q;
	input logic d, reset, clk;
	
	always_ff @(posedge clk) begin
		if (reset)
			q <= 0; // On reset, set to 0
		else
			q <= d; // Otherwise out = d
	end	
	
	
endmodule 