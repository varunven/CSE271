module shopsegment (upc, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input  logic  [2:0] upc;
	output logic  [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	always_comb   begin
		case   (upc)
			//000, PuLE
			3'b000: 
			begin
				HEX0 = 7'b1110011;
				HEX1 = 7'b0011100;
				HEX2 = 7'b0111000;
				HEX3 = 7'b1111001;
				HEX4 = 7'b0000000;
				HEX5 = 7'b0000000;
			end
			//001, ALL1GS
			3'b001:
			begin
				HEX0 = 7'b1110111;
				HEX1 = 7'b0111000;
				HEX2 = 7'b0111000;
				HEX3 = 7'b0000110;
				HEX4 = 7'b0111101;
				HEX5 = 7'b1101101;	
			end
			//011, GLo
			3'b011:
			begin
				HEX0 = 7'b0111101;
				HEX1 = 7'b0111000;
				HEX2 = 7'b1011100;	
				HEX3 = 7'b0000000;
				HEX4 = 7'b0000000;
				HEX5 = 7'b0000000;
			end
			//100, GAb
			3'b100:
			begin
				HEX0 = 7'b0111101;
				HEX1 = 7'b1110111;
				HEX2 = 7'b1111100;	
				HEX3 = 7'b0000000;
				HEX4 = 7'b0000000;
				HEX5 = 7'b0000000;
			end
			//101, Co1n
			3'b101:
			begin
				HEX0 = 7'b0111001;
				HEX1 = 7'b1011100;
				HEX2 = 7'b0000110;
				HEX3 = 7'b1010100;
				HEX4 = 7'b0000000;
				HEX5 = 7'b0000000;
			end
			//110, SbC
			3'b110:
			begin
				HEX0 = 7'b1101101;
				HEX1 = 7'b1111100;
				HEX2 = 7'b0111001;
				HEX3 = 7'b0000000;
				HEX4 = 7'b0000000;
				HEX5 = 7'b0000000;
			end
			default:
			begin
				HEX0 = 7'bX;
				HEX1 = 7'bX;
				HEX2 = 7'bX;
				HEX3 = 7'bX;
				HEX4 = 7'bX;
				HEX5 = 7'bX;
			end
		endcase
	end
endmodule

	