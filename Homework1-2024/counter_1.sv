`timescale 1ns / 1ps

module counter_1 (
  // Clk + Reset
  input   logic       Clk,
  input   logic       Rst,
  // Control Flags From Controller
  input   logic       Start_Pe,
  input   logic       En_Cnt1,
  // Counter Outputs to Controller
  output  logic [7:0] Cnt1_Out,
  output  logic       CO1
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

always_ff @(posedge Clk or posedge Rst) begin
  if (Rst) begin
    Cnt1_Out  <= '0;
  end
  else begin
    if (Start_Pe) begin
      Cnt1_Out  <= '0;
    end
    else begin
      if (En_Cnt1) begin
        Cnt1_Out  <= Cnt1_Out + 8'd1;
      end
      else begin
        Cnt1_Out  <= Cnt1_Out;
      end
    end
  end
end

assign CO1 = (Cnt1_Out == 8'd255) ? 1'b1 : 1'b0;

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
counter_1 counter_1 (
  .Clk(),
  .Rst(),
  .Start_Pe(),
  .En_Cnt1(),
  .Cnt1_Out(),
  .CO1()
);
*/
endmodule