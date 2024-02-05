`timescale 1ns/1ps

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
logic [15:0]  min_reg_r;
logic         load_min;

// temp reg nets
logic [15:0]  temp_reg_r;
logic         load_temp_r;

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
  .Min_Reg(min_reg_r),
  .Temp_Reg(temp_reg_r),
  .Sel_DMux(Sel_DMux),
  .Write_Data(Write_Data)
);

amux amux (
  .Cnt1_Out(Cnt1_Out),
  .Cnt2_Out(Cnt2_Out),
  .Sel_Mux(Sel_Mux),
  .Mux_Addr(mux_addr)
);

temp_reg temp_reg (
    .Clk(Clk),
    .Rst(Rst),
    .Load_Temp(load_temp_r),
    .Read_Data(Read_Data),
    .Temp_Reg(temp_reg_r)
);

min_reg min_reg (
    .Clk(Clk),
    .Rst(Rst),
    .Load_Min(load_min),
    .Read_Data(Read_Data),
    .Min_Reg(min_reg_r)
);

minaddr_reg minaddr_reg (
    .Clk(Clk),
    .Rst(Rst),
    .Load_Addr(load_addr),
    .Mux_Addr(mux_addr),
    .Min_Addr(min_addr)
);

comparator comparator (
    .Read_Data(Read_Data),
    .Min_Reg(min_reg_r),
    .Load_Min(Load_Min),
    .Load_Addr(load_addr),
    .Load_Min_D(load_min)
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

always_ff @(posedge Clk or posedge Rst) begin
  if (Rst) begin
    load_temp_r <= '0;
  end
  else begin
    load_temp_r <= Load_Temp;
  end
end

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
ssc_datapath ssc_datapath (
  .Clk(),
  .Rst(),
  .Read_Data(),
  .Write_Data(),
  .Address(),
  .Cnt1_Out(),
  .Cnt2_Out(),
  .Sel_AMux(),
  .Sel_DMux(),
  .Sel_Mux(),
  .Load_Min(),
  .Load_Temp()
);
*/
endmodule