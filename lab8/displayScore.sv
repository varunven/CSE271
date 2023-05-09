module displayScore (Clock, Reset, sum, hex);

	input logic Clock, Reset;
	input logic [4:0] sum;
	output logic [6:0] hex;
	
	always_comb begin
		if (sum==1) begin
			hex = 7'b1111001; end
		else if (sum==2) begin
			hex = 7'b0100100; end
		else if (sum==3) begin
			hex = 7'b0110000; end
		else if (sum==4) begin
			hex = 7'b0011001; end
		else if (sum==5) begin
			hex = 7'b0010010; end
		else if (sum==6) begin
			hex = 7'b0000010; end
		else if (sum==7) begin
			hex = 7'b1111000; end
		else if (sum==8) begin
			hex = 7'b0000000; end
		else if (sum==9) begin
			hex = 7'b0010000; end
		else begin
			hex = 7'b1000000; end //default 0
	end
		
endmodule