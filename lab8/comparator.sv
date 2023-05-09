module comparator1 (out, clk, a, b);

	output logic out;
	
	input logic clk;
	input logic [7:0] a;
	input logic [7:0] b;
	
	always_comb begin
		out = (a[7:0] > b[7:0]);
	end	
endmodule 