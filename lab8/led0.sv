module led0 (Clock, Reset, userinput, LD, lightOn, points, fullRound, totFullRound); 
//Clock, Reset, Light Reached Top, Key, Light Below On, LightOn, Points Won
//module is for led 0 representing top-most led
	input logic Clock, Reset;

	//userinput represents if the key pressed by the user (1 or 0)
	//LD represents if the light underneath is lit or not
	input logic userinput, LD, totFullRound;
	
	// when lightOn is true, the light should be on.
	output logic lightOn, fullRound;
	//uses signed integer to track points assigned
	output signed [3:0] points;
	
	logic [3:0] points;
	
	enum {on, off, pressed} ps, ns;

	always_ff @(posedge Clock) begin
		case (ps)
			off: 	
//on if light underneath lit and user doesnt press
				if(LD & !userinput) begin ns=on; lightOn=0; points=0; fullRound=0; end
				else if(LD & userinput) begin ns=pressed; lightOn=0; points=0; fullRound=0; end
				else begin ns=off; lightOn=0; points=0; fullRound=0; end
			on:	
//becomes pressed if light underneath lit and user presses and marked as lit
				if(LD & !userinput) begin ns=on; lightOn=1; points=0; fullRound=0; end
				else if(LD & userinput) begin ns=pressed; lightOn=1; points=0; fullRound=0; end
				else begin ns=off; lightOn=1; points=0; fullRound=0; end
//pressed state always returns to off and increments points
			pressed:
				if(!totFullRound) begin ns=off; lightOn=0; points=1; fullRound=1; end
				else begin ns=off; lightOn=0; points=0; fullRound=1; end
//			finishpressed:
//				begin ns=off; lightOn=0; points=-2; fullRound=1; end
//			finished:
////represents when the light has finished going up a column
//				if(LD & !userinput) begin ns=on; lightOn=1; points=0; fullRound=1; end
//				else if(LD & userinput) begin ns=finishpressed; lightOn=0; points=0; fullRound=1; end
//				else begin ns=off; lightOn=0; points=0; fullRound=1; end
		endcase		
	end

	always_ff @(posedge Clock) begin
		if (Reset)
			ps <= off;
		else
			ps <= ns;
	end
endmodule