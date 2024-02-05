`timescale 1ns / 1ps

module temp_reg (
  // Clk + Reset
  input   logic         Clk,
  input   logic         Rst,
  // Control Flag From Controller
  input   logic         Load_Temp,
  // Data From Mem Buffer
  input   logic [15:0]  Read_Data,
  // Data To Data Mux
  output  logic [15:0]  Temp_Reg
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

// Temp Register
always_ff @(posedge Clk or posedge Rst) begin
  if (Rst) begin
    Temp_Reg  <= '0;
  end
  else begin
    if (Load_Temp) begin
      Temp_Reg <= Read_Data;
    end
    else begin
      Temp_Reg <= Temp_Reg;
    end
  end
end

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
temp_reg temp_reg (
  .Clk(),
  .Rst(),
  .Load_Temp(),
  .Read_Data(),
  .Temp_Reg()
);
*/
endmodule
