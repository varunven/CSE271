module score (Clock, Reset, win, hex);

	input logic Clock, Reset;

	input logic win;

	output logic [6:0] hex;

	enum {z,o,t,th,f,fi,s,se} ps, ns;

	// Next State logic
	always_comb begin
		case (ps)
			z: if (win) 		ns = o; 
					else 			ns = z;
			
			o: if(win)			ns = t;
				else				ns = o;
					  
			t: if(win)			ns = th;
				else				ns = t;
					  
			th: if(win)			ns = f;
				else				ns = th;
					  
			f: if(win)			ns = fi;
				else				ns = f;
					  
			fi: if(win)			ns = s;
				else				ns = fi;
					  
			s: if(win)			ns = se;
				else				ns = s;
					  
			se: 					ns = se;					
		endcase
		
		if (ps==o) begin
			hex = 7'b1111001; 
		end else if (ps==t) begin
			hex = 7'b0100100; 
		end else if (ps==th) begin
			hex = 7'b0110000; 
		end else if (ps==f) begin
			hex = 7'b0011001; 
		end else if (ps==fi) begin
			hex = 7'b0010010; 
		end else if (ps==s) begin
			hex = 7'b0000010; 
		end else if (ps==se) begin
			hex = 7'b1111000; 
		end else begin
			hex = 7'b1000000; //default 0
		end
	end

	// DFFs
	always_ff @(posedge Clock) begin
		if (Reset)
			ps <= z;
		else
			ps <= ns;
	end
endmodule