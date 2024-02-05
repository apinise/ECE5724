`timescale 1ns / 1ps

module minaddr_reg (
  // Clk + Reset
  input   logic         Clk,
  input   logic         Rst,
  // Control Flag From Comparator
  input   logic         Load_Addr,
  // Data From Mux
  input   logic [7:0]   Mux_Addr,
  // Data To Address Mux
  output  logic [7:0]   Min_Addr
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

// Min Addr Register
always_ff @(posedge Clk or posedge Rst) begin
  if (Rst) begin
    Min_Addr  <= '0;
  end
  else begin
    if (Load_Addr) begin
      Min_Addr <= Mux_Addr;
    end
    else begin
      Min_Addr <= Min_Addr;
    end
  end
end

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
minaddr_reg minaddr_reg (
  .Clk(),
  .Rst(),
  .Load_Addr(),
  .Mux_Addr(),
  .Min_Addr()
);
*/
endmodule