module amux (
  input   logic [7:0] Cnt1_Out,
  input   logic [7:0] Cnt2_Out,
  input   logic       Sel_Mux,
  output  logic [7:0] Mux_Addr
);

assign Mux_Addr = Sel_Mux ? Cnt1_Out : Cnt2_Out;

endmodule