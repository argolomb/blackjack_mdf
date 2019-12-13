module deck
(
	input clk ,reset, get_card, loadseed_i,

    output reg card_rdy,

    output reg  [3:0]card_out

);

reg [0:0]mem_aux[52:0];
reg [3:0]card[52:0];

reg enable;
 
reg [31:0] seed_i;
wire [31:0] rng;

rng rng_dut(.clk(clk),
        .reset(reset),
        .loadseed_i(loadseed_i),
        .seed_i(seed_i),
        .number_o(rng),
        .enable(1'b1)
        );



always @(posedge clk or negedge reset) begin

    if (~reset) begin
        seed_i <= 0;
    end

    else begin
        seed_i<=seed_i+1;
    end
    
end

always @(posedge clk) begin
    

    card[0]<=1;card[1]<=2;card[2]<=3;card[3]<=4;card[4]<=5;card[5]<=6;card[6]<=7;card[7]<=8;card[8]<=9;card[9]<=10;card[10]<=11;card[11]<=11;card[12]<=11;
    card[13]<=1;card[14]<=2;card[15]<=3;card[16]<=4;card[17]<=5;card[18]<=6;card[19]<=7;card[20]<=8;card[21]<=9;card[22]<=10;card[23]<=11;card[24]<=11;card[25]<=11;
    card[26]<=1;card[27]<=2;card[28]<=3;card[29]<=4;card[30]<=5;card[31]<=6;card[32]<=7;card[33]<=8;card[34]<=9;card[35]<=10;card[36]<=11;card[37]<=11;card[38]<=11;
    card[39]<=1;card[40]<=2;card[41]<=3;card[42]<=4;card[43]<=5;card[44]<=6;card[45]<=7;card[46]<=8;card[47]<=9;card[48]<=10;card[49]<=11;card[50]<=11;card[51]<=11;
        

end
reg flag;

always @(posedge clk or negedge reset) begin

    if(~reset)begin
      
    flag<= 0;
    card_rdy<=0;
    card_out<=0;
    mem_aux[0]<=0;mem_aux[1]<=0;mem_aux[2]<=0;mem_aux[3]<=0;mem_aux[4]<=0;mem_aux[5]<=0;mem_aux[6]<=0;mem_aux[7]<=0;mem_aux[8]<=0;mem_aux[9]<=0;mem_aux[10]<=0;mem_aux[11]<=0;mem_aux[12]<=0;
    mem_aux[13]<=0;mem_aux[14]<=0;mem_aux[15]<=0;mem_aux[16]<=0;mem_aux[17]<=0;mem_aux[18]<=0;mem_aux[19]<=0;mem_aux[20]<=0;mem_aux[21]<=0;mem_aux[22]<=0;mem_aux[23]<=0;mem_aux[24]<=0;mem_aux[25]<=0;
    mem_aux[26]<=0;mem_aux[27]<=0;mem_aux[28]<=0;mem_aux[29]<=0;mem_aux[30]<=0;mem_aux[31]<=0;mem_aux[32]<=0;mem_aux[33]<=0;mem_aux[34]<=0;mem_aux[35]<=0;mem_aux[36]<=0;mem_aux[37]<=0;mem_aux[38]<=0;
    mem_aux[39]<=0;mem_aux[40]<=0;mem_aux[41]<=0;mem_aux[42]<=0;mem_aux[43]<=0;mem_aux[44]<=0;mem_aux[45]<=0;mem_aux[46]<=0;mem_aux[47]<=0;mem_aux[48]<=0;mem_aux[49]<=0;mem_aux[50]<=0;mem_aux[51]<=0; 

    end

    else begin
    if (loadseed_i) begin
        flag<= 1;
     end
     if (flag) begin
        if(get_card)begin

            if(~mem_aux[rng]) begin
            card_out<=card[rng];
            mem_aux[rng]<=1;
            card_rdy<=1;

            end
        
        end
      end
      
    end

end

endmodule
