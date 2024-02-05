`timescale 1ns/1ps

module ssc_wrapper (
  input   logic Clk,
  input   logic Rst,
  input   logic [7:0]  Debug_Addr,
  input   logic [15:0] Debug_Write,
  input   logic        Debug_We,
  input   logic        Debug_Read,
  input   logic Debug_En,
  input   logic Start,
  output  logic Done,
  output  logic [15:0] Read_Data
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

logic [7:0] cnt1;
logic [7:0] cnt2;

logic [15:0] read_data;
logic [15:0] write_data;
logic [7:0]  address;
logic [7:0]  ssc_address;
logic [15:0] ssc_write;
logic        ssc_read;
logic        ssc_we;
logic        read_en;
logic        write_en;

logic        load_min;
logic        load_temp;

logic [1:0]  sel_amux;
logic        sel_dmux;
logic        sel_mux;

////////////////////////////////////////////////////////////////
//////////////////////   Instantiations   //////////////////////
////////////////////////////////////////////////////////////////

ssc_datapath ssc_datapath (
  .Clk(Clk),
  .Rst(Rst),
  .Read_Data(read_data),
  .Write_Data(write_data),
  .Address(ssc_address),
  .Cnt1_Out(cnt1),
  .Cnt2_Out(cnt2),
  .Sel_AMux(sel_amux),
  .Sel_DMux(sel_dmux),
  .Sel_Mux(sel_mux),
  .Load_Min(load_min),
  .Load_Temp(load_temp)
);

ssc_controller ssc_controller (
  .Clk(Clk),
  .Rst(Rst),
  .Start(Start),
  .Done(Done),
  .Cnt1_Out(cnt1),
  .Cnt2_Out(cnt2),
  .Sel_AMux(sel_amux),
  .Sel_DMux(sel_dmux),
  .Sel_Mux(sel_mux),
  .Read_Reg(ssc_read),
  .Write_Reg(ssc_we),
  .Load_Min(load_min),
  .Load_Temp(load_temp),
  .Z()
);

mem_buffer mem_buffer (
  .Clk(Clk),
  .Rst(Rst),
  .Read(read_en),
  .Write(write_en),
  .Address(address),
  .Write_Data(write_data),
  .Read_Data(read_data)
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

// Debug assignments
assign Read_Data = read_data;
assign address = (Debug_En == 1'b1) ? Debug_Addr : ssc_address;
assign read_en = (Debug_En == 1'b1) ? Debug_Read : ssc_read;
assign write_en = (Debug_En == 1'b1) ? Debug_We : ssc_we;
assign write_data = (Debug_En == 1'b1) ? Debug_Write : ssc_write;

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
ssc_wrapper ssc_wrapper (
  .Clk(),
  .Rst(),
  .Debug_Addr(),
  .Debug_En(),
  .Start(),
  .Done(),
  .Read_Data()
);
*/
endmodule