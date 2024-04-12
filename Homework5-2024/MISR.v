 
`timescale 1ns/1ns

module MISR (clk, rst, en, poly, seed, d_in, d_out);
			
   input clk, rst, en;
   input [9: 0] poly, seed;
   input [17:0] d_in;
   output reg [9:0] d_out;
   integer i;
	
   always @(posedge clk or posedge rst) begin
      if(rst == 1'b1) 
         d_out <= seed;
      else if(en == 1'b1)begin
         d_out[9] <= (d_out[0] & poly[9]) ^ d_in[9];
         for(i = 0; i < 9; i = i + 1) begin
            d_out[i] <= (d_out[0] & poly[i]) ^ d_in[i] ^ d_out[i + 1];
         end //for
      end
   end
endmodule