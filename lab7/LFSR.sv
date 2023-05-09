module LFSR (q, reset, clk);

	output logic [9:0] q;
	input logic reset, clk;
	logic xnorbit;
	
	my_dff dff1(.q(q[0]), .d(xnorbit), .reset(reset), .clk(clk));	
	my_dff dff2(.q(q[1]), .d(q[0]), .reset(reset), .clk(clk));
	my_dff dff3(.q(q[2]), .d(q[1]), .reset(reset), .clk(clk));	
	my_dff dff4(.q(q[3]), .d(q[2]), .reset(reset), .clk(clk));
	my_dff dff5(.q(q[4]), .d(q[3]), .reset(reset), .clk(clk));	
	my_dff dff6(.q(q[5]), .d(q[4]), .reset(reset), .clk(clk));
	my_dff dff7(.q(q[6]), .d(q[5]), .reset(reset), .clk(clk));	
	my_dff dff8(.q(q[7]), .d(q[6]), .reset(reset), .clk(clk));
	my_dff dff9(.q(q[8]), .d(q[7]), .reset(reset), .clk(clk));	
	my_dff dff10(.q(q[9]), .d(q[8]), .reset(reset), .clk(clk));
	
	assign xnorbit = q[9] ~^ q[6];
endmodule