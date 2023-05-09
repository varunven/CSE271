module Row2Green(RST, GrnPixels);
    input logic RST;
    output logic [15:0][15:0] GrnPixels; // 16x16 array of green LEDs
	 
	 always_comb 
	 begin
		
		// Reset - Turn off all LEDs
		if (RST)
		begin
			GrnPixels[06] = 16'b0000000000000000;
		end
		
	  // Display a pattern
		else
		begin		  
		  //                  FEDCBA9876543210
		  GrnPixels[06] = 16'b1000010000100001;
		end
	end

endmodule