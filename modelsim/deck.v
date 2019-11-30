module deck
(
	input clk ,reset ,mix_cards;
    
    input reg [5:0] card_ctrl;
        
    output reg  [7:0] card;

);

reg [1:0] state

reg [15:0] cards[0:12]

reg [15:0] deck [0:52]


parameter SET_CARD=0, SHUFFLE_DECK=1;

always @ (posedge clk or posedge reset or posedge mix_cards) 

begin
    if(reset)
    state<=SHUFFLE_DECK;
    else
        case (state)
            SET_CARD: // OUTPUT 8-BITS

            SHUFFLE_DECK: 
            
        endcase
    end
end


endmodule
