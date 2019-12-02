module blackjack_states_tb(


);

logic clk;
logic rst;
logic shuffle;
always #5  clk =  !clk;

initial begin
    rst = 1;  clk = 0;
    @ (negedge clk);
    rst = 0;
    //repeat (10000) @ (negedge sys_clk);
    repeat (4) @ (negedge clk);
    shuffle = 1;
    @ (negedge clk);
    shuffle = 0;
      //$stop;
end

blackjack_states blackjack_dut
(
	.clk(clk), .reset(rst), .hit(), .stay(), .win(), .lose(), .tie(),
	.card_out(),.mem_ctrl_rd(), .mem_ctrl_wr(), .shuffle_ok(shuffle),
	
	.card_in(),
	.card_ctrl(),

	.player_hand(),
	.dealer_hand(),

	.player_action(),
	.dealer_action()
 );


endmodule