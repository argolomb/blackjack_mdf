module blackjack_states
(
	input	clk, reset, hit, stay;
	output card_out;
	
	input reg  [7:0] card_in;
	output reg [5:0] card_ctrl;

	output reg [7:0] player_hand;
	output reg [7:0] dealer_hand;

	output reg [7:0] player_action;
	output reg [7:0] dealer_action;

	output reg [7:0] win, lose, tie;
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
			state <= START;
		else
			case (state)
				START:
					begin
						state <= PL_CARD1;
					end
				PL_CARD1:
					begin
						state <= DL_CARD1;
					end
				DL_CARD1:
					begin
						state <= PL_CARD2;
					end
				PL_CARD2:
					begin
						state <= DL_CARD2;
					end
				DL_CARD2: //GAME OR PL_TURN 
					begin
						state <= GAME;
					end
				PL_TURN: //GAME OR DL_TURN OR PL_TURN
					begin
						state <= S1;
					end
				GAME: //STAY HERE TO MAKE MATH 
					begin
						state <= GAME;
					end
				DL_TURN: ////GAME OR DL_TURN OR PL_TURN
					begin
						state <= S1;
					end					
			endcase
	end

	// Determine the output based only on the current state
	// and the input (do not wait for a clock edge).
	always @ (state)
	begin
		case (state)
			START: // START DECK 
				begin
					state <= PL_CARD1;
				end
			PL_CARD1: //GET A CARD
				begin
					state <= DL_CARD1;
				end
			DL_CARD1: //GET A CARD
				begin
					state <= PL_CARD2;
				end
			PL_CARD2: //GET A CARD **** SET PLAYER HAND **** 
				begin
					state <= DL_CARD2;
				end
			DL_CARD2: //GET A CARD **** SET DEALER HAND
				begin
					state <= GAME;
				end
			PL_TURN: //WAIT FOR HIT OR STAY BUTTON IF SUM < 21 ELSE BURST_PLAYER **** DEALER WON
				begin
					state <= S1;
				end
			 /*
			 TIE IF PLAYER_HAND == DEALER_HAND OR BJ_P AND BJ_D OR BURST_PLAYER
			 LOSE IF BURST_PLAYER OR BLACKJACK_DEALER OR PLAYER_HAND<DEALER_HAND
			 WIN IF PLAYER_HAND>DEALER_HAND OR BLACKJACK_P OR BURST_DEALER			 
			 */
			GAME:
				begin
					state <= GAME;
				end
			DL_TURN: ////WAIT FOR HIT OR STAY BUTTON IF SUM < 21 ELSE BURST_DEALER **** PLAYER WON
				begin
					state <= S1;
				end					
		endcase
	end

endmodule
