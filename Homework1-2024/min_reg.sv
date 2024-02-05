`timescale 1ns / 1ps

module min_reg (
  // Clk + Reset
  input   logic         Clk,
  input   logic         Rst,
  // Control Flag From Comparator
  input   logic         Load_Min,
  // Data From Mem Buffer
  input   logic [15:0]  Read_Data,
  // Data To Mux
  output  logic [15:0]  Min_Reg
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

// Min Val Register
always_ff @(posedge Clk or posedge Rst) begin
  if (Rst) begin
    Min_Reg  <= '0;
  end
  else begin
    if (Load_Min) begin
      Min_Reg <= Read_Data;
    end
    else begin
      Min_Reg <= Min_Reg;
    end
  end
end

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
min_reg min_reg (
  .Clk(),
  .Rst(),
  .Load_Min(),
  .Read_Data(),
  .Min_Reg()
);
*/
endmodule