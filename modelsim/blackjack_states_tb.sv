`timescale 10ns/1ns
module blackjack_states_tb(


);


logic loadseed_i;
logic clk;
logic rst;
logic shuffle;
reg [3:0]mem[0:51];



always #5  clk =  !clk;

initial begin    
    rst = 1;  clk = 0; 
    @ (negedge clk);
    rst = 0;
    //repeat (10000) @ (negedge sys_clk);
    repeat (4) @ (negedge clk);
    loadseed_i=1;
     @ (negedge clk);
     loadseed_i=0;
      //$stop;
end

integer adddr_random;
logic [4:0] card; 


blackjack_states blackjack_dut
(
	.clk(clk), .reset(rst), .hit(1'b0), .stay(1'b0), .win(), .lose(), .tie(), .loadseed_i(loadseed_i),

	.player_hand(),
	.dealer_hand(),

	.player_action(),
	.dealer_action()
 );


endmodule