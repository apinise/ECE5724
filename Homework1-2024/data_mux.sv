module data_mux (
  input   logic [15:0]  Min_Reg,
  input   logic [15:0]  Temp_Reg,
  input   logic         Sel_DMux,
  output  logic [15:0]  Write_Data
);

assign Write_Data = Sel_DMux ? Min_Reg : Temp_Reg;

endmodule