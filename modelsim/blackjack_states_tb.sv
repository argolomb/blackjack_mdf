module blackjack_states_tb(


);

logic clk;
logic rst;
logic shuffle;
reg [3:0]mem[0:51];



always #5  clk =  !clk;

initial begin
    mem[0]=1;mem[1]=2;mem[2]=3;mem[3]=4;mem[4]=5;mem[5]=6;mem[6]=7;mem[7]=8;mem[8]=9;mem[9]=10;mem[10]=11;mem[11]=11;mem[12]=11;
    mem[13]=1;mem[14]=2;mem[15]=3;mem[16]=4;mem[17]=5;mem[18]=6;mem[19]=7;mem[20]=8;mem[21]=9;mem[22]=10;mem[23]=11;mem[24]=11;mem[25]=11;
    mem[26]=1;mem[27]=2;mem[28]=3;mem[29]=4;mem[30]=5;mem[31]=6;mem[32]=7;mem[33]=8;mem[34]=9;mem[35]=10;mem[36]=11;mem[37]=11;mem[38]=11;
    mem[39]=1;mem[40]=2;mem[41]=3;mem[42]=4;mem[43]=5;mem[44]=6;mem[45]=7;mem[46]=8;mem[47]=9;mem[48]=10;mem[49]=11;mem[50]=11;mem[51]=11;
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

integer adddr_random;
logic [4:0] card; 

always @ (posedge clk) begin
    adddr_random = $urandom()%52;
    @ (negedge clk);
    card = mem[adddr_random];
end
blackjack_states blackjack_dut
(
	.clk(clk), .reset(rst), .hit(1'b0), .stay(1'b0), .win(), .lose(), .tie(),
	.card_out(),.mem_ctrl_rd(), .mem_ctrl_wr(), .shuffle_ok(shuffle),
	
	.card_in(card),
	.card_ctrl(),

	.player_hand(),
	.dealer_hand(),

	.player_action(),
	.dealer_action()
 );


endmodule