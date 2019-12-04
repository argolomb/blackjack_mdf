`timescale 10ns/1ns
 
module rng_tb;
 
reg clk;
reg reset;
reg loadseed_i;
reg enable;
 
reg [31:0] seed_i;
wire [31:0] number_o;
 
rng rng_dut(clk,reset,loadseed_i,seed_i,number_o,enable);
 
   initial
 
   begin
     
     clk = 1'b1;
     reset = 1'b1;  
     loadseed_i = 1'b0;
     seed_i=32'h12345678;     
     @(posedge clk);
     reset = #1 1'b0;
     @(posedge clk);
     reset = #1 1'b1;
     @(posedge clk);
	 loadseed_i = #1 1'b1;
	 @(posedge clk);
	 loadseed_i = #1 1'b0;

    repeat (4) @ (negedge clk);
    enable = 1;
    @ (negedge clk);
    enable = 0;
 
	 while(1)
	 begin
	   @(posedge clk);
       $display("%H",number_o);
	 end
 
 
     $finish;
 
   end
 
   always #2 clk = !clk;

   
 
endmodule
 