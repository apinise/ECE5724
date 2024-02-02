module addr_mux (
  input   logic [7:0] Cnt1_Out,
  input   logic [7:0] Cnt2_Out,
  input   logic [7:0] Min_Addr,
  input   logic [1:0] Sel_AMux,
  output  logic [7:0] Address
);

always_comb begin
  casez(Sel_AMux)
    2'b00: Address = Cnt1_Out;
    2'b01: Address = Cnt2_Out;
    2'b10: Address = Min_Addr;
    default: Address = '0;
  endcase
end

endmodule