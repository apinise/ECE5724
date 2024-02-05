`timescale 1ns / 1ps

module addr_mux (
  // Mux Inputs
  input   logic [7:0] Cnt1_Out,
  input   logic [7:0] Cnt2_Out,
  input   logic [7:0] Min_Addr,
  // Mux Selection
  input   logic [1:0] Sel_AMux,
  // Mux Output
  output  logic [7:0] Address
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

always_comb begin
  casez(Sel_AMux)
    2'b00: Address = Cnt1_Out;
    2'b01: Address = Cnt2_Out;
    2'b10: Address = Min_Addr;
    default: Address = '0;
  endcase
end

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
addr_mux addr_mux (
  .Cnt1_Out(),
  .Cnt2_Out(),
  .Min_Addr(),
  .Sel_AMux(),
  .Address()
);
*/
endmodule