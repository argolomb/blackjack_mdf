module blackjack_states
(
	input	clk, reset, hit, stay, loadseed_i,

	output reg win, lose, tie, 
	
	output reg [7:0] player_hand,
	output reg [7:0] dealer_hand,

	output reg [1:0]player_action,
	output reg [1:0] dealer_action
 );
	// Declare state register
	reg	[2:0]state;
	reg [4:0]sum_d, sum_p, sum_d_aux;

	reg bj_p, 
	bj_d, 
	burst_p, 
	burst_d, 
	has_ace_p,
	has_ace_d,
	stay_d,
	stay_d_wire,
	stay_p, 
	hit_d, 
	hit_d_wire,
	hit_p, 
	bj_d_wire,
	bj_p_wire,
	burst_p_wire, 
	burst_d_wire;



    //wire shuffle_ok;
    wire [3:0] card_in;
	wire card_rdy;
	reg [3:0]card_aux;
	reg get_card;
	reg flag_stay;

	// Declare states
deck deck_0(
		.clk(clk) ,
		.loadseed_i(loadseed_i),
		.reset(~reset),
		.get_card(get_card),
		.card_rdy(card_rdy),
		.card_out(card_in)
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
					if(card_rdy)
					begin
						state <= PL_CARD1;
					end
				else
					begin
					state<=START;  
					end
				PL_CARD1:
					if (card_rdy) begin
					
					state <= DL_CARD1;
					end
					else begin
					  state<=PL_CARD1;
					end


				DL_CARD1:
					if(card_rdy) begin
						state <= PL_CARD2;
					end
					else begin
						state<=DL_CARD1;
					end
				PL_CARD2:
					if(card_rdy) begin
						state <= DL_CARD2;
					end
					else begin
						state<=PL_CARD2;
					end

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
						if(burst_p_wire || burst_d_wire)
							begin
								state<=GAME;
							end
						else if(stay || hit_p)
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
					
					else if(flag_stay || hit_d) begin
						state<=PL_TURN;
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
					sum_p<=0;
					sum_d<=0;
					has_ace_p<=0;
					has_ace_d<=0;
					win=0;
					lose=0;
					tie=0;
					get_card<=1;
					flag_stay<=0;
									
				end
			PL_CARD1: //GET A CARD				
				if(card_aux == 11)
				begin
					sum_p<=sum_p+card_aux-1;
					has_ace_p<=1;
					
				end
				else
					begin
					sum_p<=sum_p+card_aux;
					
				end
				
			DL_CARD1: //GET A CARD
				if(card_aux == 11)
					begin
						sum_d<=sum_d+card_aux-1;
						has_ace_d<=1;
						
					end
				else
					begin
						sum_d<=sum_d+card_aux;
						
					end
					
			PL_CARD2: //GET A CARD **** SET PLAYER HAND **** 
				begin
					if(card_aux == 11)
						begin
							sum_p<=sum_p+card_aux-1;
							has_ace_p<=1;
							
						end
					else if (card_aux == 1 && has_ace_p) 
						begin
							sum_p<=sum_p+11;
						end
					else begin
						sum_p=sum_p+card_aux;
					end
				end
			DL_CARD2: //GET A CARD **** SET DEALER HAND
				begin
					get_card=0;
					if(card_aux == 11)
						begin
							sum_d<=sum_d+card_aux-1;
							has_ace_d<=1;
							
						end
					else if (card_aux == 1 && has_ace_d) 
						begin
							sum_p<=sum_p+11;
						end
					else
						begin
							sum_d<=sum_d+card_aux;
							
						end
				end
			PL_TURN: //WAIT FOR HIT OR STAY BUTTON IF SUM 				
				if ((hit && ~burst_p_wire)||(stay_d)) begin
					get_card<=1;
					if(card_in == 11)
						begin
							sum_p<=sum_p+card_in-1;
							has_ace_p<=1;
							flag_stay<=0;
							
						end
					if (card_in == 1 && has_ace_p) 
						begin
							sum_p<=sum_p+11;
							flag_stay<=0;
						end
					else
						begin
							sum_p<=sum_p+card_in;
							flag_stay<=0;
						end					
				end		
			
			DL_TURN: ////WAIT FOR HIT OR STAY BUTTON IF SUM < 21 ELSE BURST_DEALER **** PLAYER WON
				begin
					get_card=0;
					if(card_rdy) begin
						if ((hit_d && ~burst_d_wire)||(stay)||(~flag_stay)) begin
							if(card_in == 11)
								begin
									sum_d<=sum_d+card_in-1;
									has_ace_d<=1;
									flag_stay<=1;
								end
							if (card_in == 1 && has_ace_d) 
								begin
									sum_d=sum_d+11;
									flag_stay<=1;
								end
							else
								begin
									sum_d<=sum_d+card_in;
									flag_stay<=1;									
								end					
						end				
					
						else if (sum_d_aux<=16 && ~stay)
							begin
								hit_d_wire<=1;
								stay_d_wire<=0;
								flag_stay<=1;
							end
						else if (sum_d_aux>=17) 
							begin
								stay_d_wire<=1;
								hit_d_wire<=0;
								flag_stay<=1;
							end
					end
				end

			 /*
			 TIE IF PLAYER_HAND == DEALER_HAND OR BJ_P AND BJ_D OR BURST_PLAYER
			 LOSE IF BURST_PLAYER OR BLACKJACK_DEALER OR PLAYER_HAND<DEALER_HAND
			 WIN IF PLAYER_HAND>DEALER_HAND OR BLACKJACK_P OR BURST_DEALER			 
			 */
			GAME:
				
				if((sum_d == sum_p)||(burst_p_wire && burst_d_wire))
					begin
						tie<=1;
					end	
				else if ((sum_d==21 && sum_p<21)||(burst_p_wire)) 
					begin
						lose<=1;
					end
				else if ((sum_p==21 && sum_d<21)||(burst_d_wire))
					begin
						win<=1;
					end
				
		endcase
	end

always @ (*) begin
	burst_p_wire=0;
	burst_d_wire=0;
	bj_p_wire=0;
	bj_d_wire=0;


	if(sum_p>21) 
		begin
			burst_p_wire<=1;
		end
	else if (sum_p==21)
		begin
		bj_p_wire<=1;
		end
	else if(sum_d>21) 
		begin
			burst_d_wire<=1;
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
	hit_p<=hit;
	hit_d<=hit_d_wire;
	stay_d<=stay_d_wire;
	card_aux<=card_in;
	sum_d_aux<=sum_d;
	end

endmodule
