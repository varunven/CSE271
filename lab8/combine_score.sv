module combine_score(sum, p7, p6, p5, p4, p3, p2, p1, p0);
	input logic [3:0] p7, p6, p5, p4, p3, p2, p1, p0;
	output logic [3:0] sum;
	logic [3:0] tempsum, tempsum1, tempsum2, tempsum3, tempsum4, tempsum5, tempsum6;
	logic [3:0] carryover1, carryover2, carryover3, carryover4, carryover5, carryover6, carryover7;
	
	bit4adder o(carryover1, tempsum1, p0, p1, 0); 
	bit4adder t(carryover2, tempsum2, tempsum1, p2, carryover1);
	bit4adder th(carryover3, tempsum3, tempsum2, p3, carryover2);
	bit4adder f(carryover4, tempsum4, tempsum3, p4, carryover3);
	bit4adder fi(carryover5, tempsum5, tempsum4, p5, carryover4);
	bit4adder s(carryover6, tempsum6, tempsum5, p6, carryover5);
	bit4adder se(carryover7, tempsum, tempsum6, p7, carryover6);
	
	always_comb begin
		if(tempsum<0) begin sum<=0; end
		else begin sum<=tempsum; end
	end
endmodule

module bit4adder(C, S, A, B, Cin);
	input [3:0] A, B;
	output [3:0] S;
	input logic Cin;
	output logic C;
	
	logic C1, C2, C3, C4, C5, C6;
	
	full_adder FA0 (C1, S[0], A[0], B[0], Cin);
	full_adder FA1 (C2, S[1], A[1], B[1], C1);
	full_adder FA2 (C3, S[2], A[2], B[2], C2);
	full_adder FA3 (C, S[3], A[3], B[3], C3);

endmodule 

module full_adder(Co, S, A, B, Ci);
	input A, B, Ci;
	output Co, S;
	
	logic sum;
	logic c_first, c_second; // carry of first/second half_adder
	
	half_adder first (c_first, sum, A, B);
	half_adder second (c_second, S, sum, Ci);
	
	assign Co = c_first | c_second;
	
endmodule

module half_adder(C, S, A, B);
	input A, B;
	output C, S;
	
	assign S = A ^ B;
	assign C = A & B;
endmodule 

module combine_score_testbench();
	logic [3:0] sum, p7, p6, p5, p4, p3, p2, p1, p0;
	logic clk;
	
	combine_score dut (sum, p7, p6, p5, p4, p3, p2, p1, p0);
	
	// Set up the clock.
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		p7<=0;		repeat(2)@(posedge clk);  p6<=0;		repeat(2)@(posedge clk);  p5<=0;		repeat(2)@(posedge clk);  p4<=1;		repeat(2)@(posedge clk);  p3<=-2;		repeat(2)@(posedge clk);  p2<=0;		repeat(2)@(posedge clk);  p1<=0;		repeat(2)@(posedge clk);  p0<=-2;		repeat(2)@(posedge clk);
		p7<=2;		repeat(2)@(posedge clk);  p6<=2;		repeat(2)@(posedge clk);  p5<=0;		repeat(2)@(posedge clk);  p4<=2;		repeat(2)@(posedge clk);  p3<=1;		repeat(2)@(posedge clk);  p2<=0;		repeat(2)@(posedge clk);  p1<=0;		repeat(2)@(posedge clk);  p0<=0;		repeat(2)@(posedge clk);
		p7<=1;		repeat(2)@(posedge clk);  p6<=2;		repeat(2)@(posedge clk);  p5<=1;		repeat(2)@(posedge clk);  p4<=0;		repeat(2)@(posedge clk);  p3<=2;		repeat(2)@(posedge clk);  p2<=2;		repeat(2)@(posedge clk);  p1<=1;		repeat(2)@(posedge clk);  p0<=1;		repeat(2)@(posedge clk);
		p7<=-2;		repeat(2)@(posedge clk);  p6<=2;		repeat(2)@(posedge clk);  p5<=0;		repeat(2)@(posedge clk);  p4<=2;		repeat(2)@(posedge clk);  p3<=2;		repeat(2)@(posedge clk);  p2<=2;		repeat(2)@(posedge clk);  p1<=0;		repeat(2)@(posedge clk);  p0<=-2;		repeat(2)@(posedge clk);
		$stop;
	end
		
endmodule
	

