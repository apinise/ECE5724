`timescale 1ns / 1ps

module counter_2 (
  // Clk + Reset
  input   logic       Clk,
  input   logic       Rst,
  // Control Flags From Controller
  input   logic       Start_Pe,
  input   logic       En_Cnt2,
  input   logic       Pl_Cnt2,
  input   logic [7:0] Cnt1_Out,
  // Counter Outputs To Controller
  output  logic [7:0] Cnt2_Out,
  output  logic       CO2
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

always_ff @(posedge Clk or posedge Rst) begin
  if (Rst) begin
    Cnt2_Out  <= '0;
  end
  else begin
    if (Start_Pe) begin
      Cnt2_Out  <= 8'd1;
    end
    else begin
      if (Pl_Cnt2) begin
        Cnt2_Out  <= Cnt1_Out + 8'd1;
      end
      else if (En_Cnt2) begin
        Cnt2_Out  <= Cnt2_Out + 8'd1;
      end
    end
  end
end

assign CO2 = (Cnt2_Out == 8'd255) ? 1'b1 : 1'b0;
////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
counter_1 counter_1 (
  .Clk(),
  .Rst(),
  .Start_Pe(),
  .En_Cnt2(),
  .Pl_Cnt2()
  .Cnt1_Out(),
  .Cnt2_Out(),
  .CO2()
);
*/
endmodule