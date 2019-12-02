module blackjack_states
(
	input	clk, reset, hit, stay, shuffle_ok,

	output reg card_out,mem_ctrl_rd, mem_ctrl_wr, win, lose, tie, 
	
	input [7:0] card_in, 
	output reg [5:0] card_ctrl,

	output reg [7:0] player_hand,
	output reg [7:0] dealer_hand,

	output reg [7:0] player_action,
	output reg [7:0] dealer_action
 );
	// Declare state register
	reg	[2:0]state;
	reg [5:0]mem_addr;
	reg [4:0]sum_d, sum_p;

	reg bj_p, 
	bj_d, 
	burst_p, 
	burst_d, 
	has_ace_p,
	has_ace_d,
	stay_d,
	stay_p, 
	mix_cards, 
	hit_d, hit_p, 
	bj_d_wire,
	bj_p_wire,
	burst_p_wire, 
	burst_d_wire;


    //wire shuffle_ok;
    wire [7:0] card;
	// Declare states
// deck deck_0(
// 		.clk(clk) ,
// 		.reset(reset) ,
// 		.mix_cards(mix_cards),
//     	.card_ctrl(card_ctrl),        
//     	.card(card),
// 		.shuffle_ok(shuffle_ok)

// );
	
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
					state<=START;  
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
				PL_TURN: 
					begin //GAME OR DL_TURN OR PL_TURN
						if(burst_p)
							begin
								state<=GAME;
							end
						else
							begin
								state<=PL_TURN;
							end
						if(stay)
							begin
								state<=DL_TURN;
							end
						else
							begin
								state<=PL_TURN;
							end
					end 

				GAME: //STAY HERE TO MAKE MATH 
					state <= GAME;
				
				DL_TURN: ////GAME OR DL_TURN
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
				begin
					mix_cards <= 1;	
					mem_addr <= 0;
					mem_ctrl_rd <= 1;
					sum_p<=0;
					sum_d<=0;
					has_ace_p<=0;
					burst_d<=0;
					burst_p<=0;
				end
			PL_CARD1: //GET A CARD				
				if(card_in == 11)
				begin
					sum_p<=sum_p+card_in-1;
					has_ace_p<=1;
					mem_addr<=mem_addr+1;
				end
				else
					begin
					sum_p<=sum_p+card_in;
					mem_addr<=mem_addr+1;
				end
				
			DL_CARD1: //GET A CARD
				if(card_in == 11)
					begin
						sum_d<=sum_d+card_in-1;
						has_ace_d<=1;
						mem_addr<=mem_addr+1;
					end
				else
					begin
						sum_d<=sum_d+card_in;
						mem_addr<=mem_addr+1;
					end
					
			PL_CARD2: //GET A CARD **** SET PLAYER HAND **** 
				if(card_in == 11)
					begin
						sum_p<=sum_p+card_in-1;
						has_ace_p<=1;
						mem_addr<=mem_addr+1;
					end
				else if (card_in == 1 && has_ace_p) 
					begin
						sum_p=sum_p+11;
					end
				else if(sum_p>21) 
					begin
						burst_p<=1;
					end
					
			DL_CARD2: //GET A CARD **** SET DEALER HAND
				if(card_in == 11)
					begin
						sum_d<=sum_d+card_in-1;
						has_ace_d<=1;
						mem_addr<=mem_addr+1;
					end
				else if (card_in == 1 && has_ace_d) 
					begin
						sum_p=sum_p+11;
					end
				else
					begin
						sum_d<=sum_d+card_in;
						mem_addr<=mem_addr+1;
					end

			PL_TURN: //WAIT FOR HIT OR STAY BUTTON IF SUM 				
			
				if (hit && ~burst_p_wire) begin
					if(card_in == 11)
						begin
							sum_p<=sum_p+card_in-1;
							has_ace_p<=1;
							mem_addr<=mem_addr+1;
						end
					if (card_in == 1 && has_ace_p) 
						begin
							sum_p=sum_p+11;
						end
					else
						begin
							sum_p<=sum_p+card_in;
							mem_addr<=mem_addr+1;
						end					
				end
				else if(stay && ~burst_p_wire)
					begin
						stay_d<=1;
					end				
			
			DL_TURN: ////WAIT FOR HIT OR STAY BUTTON IF SUM < 21 ELSE BURST_DEALER **** PLAYER WON

				if (hit && ~burst_d_wire) begin
					if(card_in == 11)
						begin
							sum_d<=sum_d+card_in-1;
							has_ace_d<=1;
							mem_addr<=mem_addr+1;
						end
					if (card_in == 1 && has_ace_d) 
						begin
							sum_d=sum_d+11;
						end
					else
						begin
							sum_d<=sum_d+card_in;
							mem_addr<=mem_addr+1;
						end					
				end

				else if(stay && ~burst_d_wire)
					begin
						stay_p<=1;
					end

			 /*
			 TIE IF PLAYER_HAND == DEALER_HAND OR BJ_P AND BJ_D OR BURST_PLAYER
			 LOSE IF BURST_PLAYER OR BLACKJACK_DEALER OR PLAYER_HAND<DEALER_HAND
			 WIN IF PLAYER_HAND>DEALER_HAND OR BLACKJACK_P OR BURST_DEALER			 
			 */
			GAME:
				
				if((sum_d == sum_p)||(burst_p && burst_d))
					begin
						tie<=1;
					end
				else if ((sum_d==21 && sum_p<21)||(burst_p)) 
					begin
						lose<=1;
					end
				else if ((sum_p==21 && sum_d<21)||(burst_d))
					begin
						win<=1;
					end
				
		endcase
	end

always @ (*) begin
	burst_p_wire<=0;
	burst_d_wire<=0;
	bj_p_wire<=0;
	bj_d_wire<=0;


	if(sum_p>21) 
		begin
			burst_p_wire=1;
		end
	else if (sum_p==21)
		begin
		bj_p_wire=1;
		end
	else if(sum_d>21) 
		begin
			burst_d_wire=1;
		end
	else if(sum_d==21)
		begin
			bj_d_wire<=1;
		end
end

always @ (posedge clk) begin
	burst_p<=burst_p_wire;
	burst_d<=burst_d_wire;
	bj_p<=bj_p_wire;
	bj_d<=bj_d_wire;
end

endmodule
