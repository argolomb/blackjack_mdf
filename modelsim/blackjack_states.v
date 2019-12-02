module blackjack_states
(
	input	clk, reset, hit, stay,
	output card_out,mem_ctrl_rd, mem_ctrl_wr
	
	input [15:0] card_in,
	output reg [5:0] card_ctrl,

	output reg [7:0] player_hand,
	output reg [7:0] dealer_hand,

	output reg [7:0] player_action,
	output reg [7:0] dealer_action,

	output reg [7:0] win, lose, tie
);
	// Declare state register
	reg	[2:0]state;
	reg [5:0]mem_addr
	reg [4:0]sum_d, sum_p

	reg bj_p, bj_d, burst_p, burst_d, has_ace_p,twone_p,stay_d, mix_cards, ;


    wire shuffle_ok;
    wire [5:0] card_ctrl;
    wire [7:0] card;
	// Declare states
deck deck_0(
		.clk(clk) ,
		.reset(reset) ,
		.mix_cards(mix_cards),
    	.card_ctrl(card_ctrl),        
    	.card(card)
		.shuffle_ok(shuffle_ok)

);
	
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
					if(shuffle_ok)
					begin
						state <= PL_CARD1;
					end
				else
					begin
					state<=START  
					end
				PL_CARD1:
					state <= DL_CARD1;
				
				DL_CARD1:
					state <= PL_CARD2;
				
				PL_CARD2:
					state <= DL_CARD2;
		
				DL_CARD2: //GAME OR PL_TURN 
					if(bj_d || bj_p)
						begin
							state<=GAME;
						end
					else
						begin
							state <= PL_TURN;
						end
				PL_TURN: //GAME OR DL_TURN OR PL_TURN
					if(burst_p && !has_ace_p)
						begin
							state<=GAME;
						end
					else
						begin
							state<=PL_TURN;
						end
					if(stay || twone_p)
						begin
							state<=DL_TURN;
						end
					else
						begin
							state<=PL_TURN;
						end
				
				GAME: //STAY HERE TO MAKE MATH 
					state <= GAME;
				
				DL_TURN: ////GAME OR DL_TURN OR PL_TURN
					if(stay_d || burst_d)
						begin
							state<=GAME;
						end
					else
						begin
							state<=DL_TURN;
						end
			endcase
	end

	// Determine the output based only on the current state
	// and the input (do not wait for a clock edge).
	always @ (posedge clk)
	begin
		case (state)
			START: // START DECK 
				mix_cards <= 1;	
				mem_addr <= 0;
				mem_ctrl_rd <= 1;
				sum_p<=0;
				sum_d<=0;
				has_ace_p<=0

			PL_CARD1: //GET A CARD				
				if(card_in == 11)
				begin
					sum_p<=sum_p+card_in-1;
					has_ace_p<=1;
					mem_addr<=mem_addr+1
				end
				else
					begin
					sum_p<=sum_p+card_in;
					mem_addr<=mem_addr+1
					end
				
			DL_CARD1: //GET A CARD
				if(card_in == 11)
					begin
						sum_p<=sum_p+card_in-1;
						has_ace_p<=1;
						mem_addr<=mem_addr+1
					end
				else
					begin
						sum_p<=sum_p+card_in;
						mem_addr<=mem_addr+1
					end
					
				
			PL_CARD2: //GET A CARD **** SET PLAYER HAND **** 
				
					
				
			DL_CARD2: //GET A CARD **** SET DEALER HAND
			
					
			
			PL_TURN: //WAIT FOR HIT OR STAY BUTTON IF SUM < 21 ELSE BURST_PLAYER **** DEALER WON
			
			 /*
			 TIE IF PLAYER_HAND == DEALER_HAND OR BJ_P AND BJ_D OR BURST_PLAYER
			 LOSE IF BURST_PLAYER OR BLACKJACK_DEALER OR PLAYER_HAND<DEALER_HAND
			 WIN IF PLAYER_HAND>DEALER_HAND OR BLACKJACK_P OR BURST_DEALER			 
			 */
			GAME:

			DL_TURN: ////WAIT FOR HIT OR STAY BUTTON IF SUM < 21 ELSE BURST_DEALER **** PLAYER WON
			
		endcase
	end

endmodule
