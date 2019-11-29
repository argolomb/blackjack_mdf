// Quartus Prime Verilog Template
// 4-State Mealy state machine

// A Mealy machine has outputs that depend on both the state and 
// the inputs.  When the inputs change, the outputs are updated
// immediately, without waiting for a clock edge.  The outputs
// can be written more than once per state or per clock cycle.

module blackjack_states
(
	input	clk, in, reset, hit, stay
	output reg [1:0] out
);

	// Declare state register
	reg		[2:0]state;

	// Declare states
	
	//PL_CARDx == PLAYER CARD; DL_CARDx=DEALER CARD; PL_TURN=PLAYER TURN;DL_TURN=DEALER TURN
	
	parameter START = 0, PL_CARD1 = 1, DL_CARD1 = 2, PL_CARD2 = 3, DL_CARD2 = 4,
	PL_TURN=5, GAME=6, DL_TURN=7;

	// Determine the next state synchronously, based on the
	// current state and the input
	always @ (posedge clk or posedge reset) begin
		if (reset)
			state <= S0;
		else
			case (state)
				START:
					if (in)
					begin
						state <= S1;
					end
					else
					begin
						state <= S1;
					end
				PL_CARD1:
					if (in)
					begin
						state <= S1;
					end
					else
					begin
						state <= S1;
					end
				DL_CARD1:
					if (in)
					begin
						state <= S1;
					end
					else
					begin
						state <= S1;
					end
				PL_CARD2:
					if (in)
					begin
						state <= S1;
					end
					else
					begin
						state <= S1;
					end
				DL_CARD2:
					if (in)
					begin
						state <= S1;
					end
					else
					begin
						state <= S1;
					end
				PL_TURN:
					if (in)
					begin
						state <= S1;
					end
					else
					begin
						state <= S1;
					end
				GAME:
					if (in)
					begin
						state <= S1;
					end
					else
					begin
						state <= S1;
					end
				DL_TURN:
					if (in)
					begin
						state <= S1;
					end
					else
					begin
						state <= S1;
					end					
			endcase
	end

	// Determine the output based only on the current state
	// and the input (do not wait for a clock edge).
	always @ (state or in)
	begin
			case (state)
				START:
					
				PL_CARD1:
					
				DL_CARD1:
					
				PL_CARD2:

                DL_CARD2:

                GAME:

                PL_TURN:

                DL_TURN:
					
			endcase
	end

endmodule

	begin
			case (state)
				S0:
					if (in)
					begin
						out = 2'b00;
					end
					else
					begin
						out = 2'b10;
					end
				S1:
					if (in)
					begin
						out = 2'b01;
					end
					else
					begin
						out = 2'b00;
					end
				S2:
					if (in)
					begin
						out = 2'b10;
					end
					else
					begin
						out = 2'b01;
					end
				S3:
					if (in)
					begin
						out = 2'b11;
					end
					else
					begin
						out = 2'b00;
					end
			endcase
	end

endmodule
