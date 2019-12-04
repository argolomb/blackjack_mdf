module deck
(
	input clk ,reset ,shuffle, get_card, [5:0]addr_aux;
    
    output card_ready, shuffle_ok;
            
    output reg  [3:0]card_out, [5:0]mem_addr;

);

reg [2:0] state;

reg [3:0] cards[0:12];

reg shuffle_ok;

reg i;

reg [3:0]deck_aux[0:52];

parameter SHUFFLE_DECK=0, GET_CARD=1, CARD_OUT=2;

always @ (posedge clk or posedge reset) 

    begin
        if(reset)
        state<=SHUFFLE_DECK;
        else
            case (state)
                SHUFFLE_DECK:
                    if (shufle_ok) begin
                        state<=GET_CARD;
                    end
                    else begin
                        state<=SHUFFLE_DECK;
                    end
                GET_CARD:
                    if (get_card) begin
                        state<=CARD_OUT;
                    end
                    else begin
                    state<=GET_CARD;
                    end
                CARD_OUT:
                    if (card_out) begin
                        state<=GET_CARD;
                    end
                    else begin
                        state<=CARD_OUT;
            endcase
        end
    end



//Condicional
always @ (posedge clk) 

    begin
            case (state)
                SHUFFLE_DECK:
                    begin
                        shuffle<=1;
                    end
                GET_CARD:
                    begin
                        if(shuffle_ok)
                        card_out<=
                    end

                CARD_OUT:
                    begin
                        
                    end
            endcase
        end
    end


endmodule
