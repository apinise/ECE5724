module ssc_datapath (
  // Clk + Reset
  input   logic Clk,
  input   logic Rst,
  // Data Mem Interface
  input   logic [15:0]  Read_Data,
  output  logic [15:0]  Write_Data,
  output  logic [7:0]   Address,
  // Controller Interface
  input   logic [7:0]   Cnt1_Out,
  input   logic [7:0]   Cnt2_Out,
  input   logic [1:0]   Sel_AMux,
  input   logic         Sel_DMux,
  input   logic         Sel_Mux,
  input   logic         Load_Min,
  input   logic         Load_Temp
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

// amux nets
logic [7:0] mux_addr;

// min addr nets
logic [7:0] min_addr;
logic       load_addr;

// min reg nets
logic [15:0]  min_reg;
logic         load_min;

// temp reg nets
logic [15:0]  temp_reg;

// comparator nets
logic         lt;

////////////////////////////////////////////////////////////////
//////////////////////   Instantiations   //////////////////////
////////////////////////////////////////////////////////////////

addr_mux addr_mux (
  .Cnt1_Out(Cnt1_Out),
  .Cnt2_Out(Cnt2_Out),
  .Min_Addr(min_addr),
  .Sel_AMux(Sel_AMux),
  .Address(Address)
);

data_mux data_mux (
  .Min_Reg(min_reg),
  .Temp_Reg(temp_reg),
  .Sel_DMux(Sel_DMux),
  .Write_Data(Write_Data)
);

amux amux (
  .Cnt1_Out(Cnt1_Out),
  .Cnt2_Out(Cnt2_Out),
  .Sel_Mux(Sel_Mux),
  .Mux_Addr(mux_addr)
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

// Min Addr Register
always_ff @(posedge Clk or posedge Rst) begin
  if (Rst) begin
    min_addr  <= '0;
  end
  else begin
    if (load_addr) begin
      min_addr <= mux_addr;
    end
    else begin
      min_addr <= min_addr;
    end
  end
end

// Min Val Register
always_ff @(posedge Clk or posedge Rst) begin
  if (Rst) begin
    min_reg  <= '0;
  end
  else begin
    if (load_min) begin
      min_reg <= Read_Data;
    end
    else begin
      min_reg <= min_reg;
    end
  end
end

// Temp Register
always_ff @(posedge Clk or posedge Rst) begin
  if (Rst) begin
    temp_reg  <= '0;
  end
  else begin
    if (Load_Temp) begin
      temp_reg <= Read_Data;
    end
    else begin
      temp_reg <= temp_reg;
    end
  end
end

// Comparator
assign lt = (Read_Data < min_reg) ? 1'b1 : 1'b0;
assign load_min = (Load_Min | lt) ? 1'b1 : 1'b0;
assign load_addr = (Load_Min | lt) ? 1'b1 : 1'b0;

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////

endmodule