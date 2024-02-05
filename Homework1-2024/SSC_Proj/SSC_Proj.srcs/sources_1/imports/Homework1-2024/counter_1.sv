module counter_1 (
    input   logic   Clk,
    input   logic   Rst,
    input   logic   Start_Pe,
    input   logic   En_Cnt1,
    output  logic   [7:0]   Cnt1_Out,
    output  logic           CO1
);

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

endmodule