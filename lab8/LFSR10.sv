module LFSR1 (q, reset, clk);

	output logic [7:0] q;
	input logic reset, clk;
	logic xnorbit;
	
	my_dff dff1(.q(q[0]), .d(xnorbit), .reset(reset), .clk(clk));	
	my_dff dff2(.q(q[1]), .d(q[0]), .reset(reset), .clk(clk));
	my_dff dff3(.q(q[2]), .d(q[1]), .reset(reset), .clk(clk));	
	my_dff dff4(.q(q[3]), .d(q[2]), .reset(reset), .clk(clk));
	my_dff dff5(.q(q[4]), .d(q[3]), .reset(reset), .clk(clk));	
	my_dff dff6(.q(q[5]), .d(q[4]), .reset(reset), .clk(clk));
	my_dff dff7(.q(q[6]), .d(q[5]), .reset(reset), .clk(clk));	
	
	assign xnorbit = q[6] ~^ q[5];
endmodule

module LFSR2 (q, reset, clk);

	output logic [27:0] q;
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
	my_dff dff11(.q(q[10]), .d(q[9]), .reset(reset), .clk(clk));	
	my_dff dff12(.q(q[11]), .d(q[10]), .reset(reset), .clk(clk));
	my_dff dff13(.q(q[12]), .d(q[11]), .reset(reset), .clk(clk));	
	my_dff dff14(.q(q[13]), .d(q[12]), .reset(reset), .clk(clk));
	my_dff dff15(.q(q[14]), .d(q[13]), .reset(reset), .clk(clk));	
	my_dff dff16(.q(q[15]), .d(q[14]), .reset(reset), .clk(clk));
	my_dff dff17(.q(q[16]), .d(q[15]), .reset(reset), .clk(clk));	
	my_dff dff18(.q(q[17]), .d(q[16]), .reset(reset), .clk(clk));
	my_dff dff19(.q(q[18]), .d(q[17]), .reset(reset), .clk(clk));	
	my_dff dff20(.q(q[19]), .d(q[18]), .reset(reset), .clk(clk));
	my_dff dff21(.q(q[20]), .d(q[19]), .reset(reset), .clk(clk));	
	my_dff dff22(.q(q[21]), .d(q[20]), .reset(reset), .clk(clk));
	my_dff dff23(.q(q[22]), .d(q[21]), .reset(reset), .clk(clk));	
	my_dff dff24(.q(q[23]), .d(q[22]), .reset(reset), .clk(clk));
	my_dff dff25(.q(q[24]), .d(q[23]), .reset(reset), .clk(clk));	
	my_dff dff26(.q(q[25]), .d(q[24]), .reset(reset), .clk(clk));
	my_dff dff27(.q(q[26]), .d(q[25]), .reset(reset), .clk(clk));	
	my_dff dff28(.q(q[27]), .d(q[26]), .reset(reset), .clk(clk));	

	assign xnorbit = q[27] ~^ q[24];
endmodule