`timescale 1ns/1ps

module ssc_controller (
  // Clk + Reset
  input   logic   Clk,
  input   logic   Rst,
  // Status Flags
  input   logic   Start,
  output  logic   Done,
  // Counter Values
  output  logic [7:0] Cnt1_Out,
  output  logic [7:0] Cnt2_Out,
  // Mux Ctrl
  output  logic [1:0] Sel_AMux,
  output  logic       Sel_DMux,
  output  logic       Sel_Mux,
  // Mem Buffer Ctrl
  output  logic       Read_Reg,
  output  logic       Write_Reg,
  // Reg Ctrl
  output  logic       Load_Min,
  output  logic       Load_Temp,
  // FSM State
  output  logic [2:0] Z
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

localparam  S_IDLE    = 3'b000,
            S_START   = 3'b001,
            S_INIT    = 3'b010,
            S_FIND    = 3'b011,
            S_UPDATE0 = 3'b100,
            S_UPDATE1 = 3'b101,
            S_UPDATE2 = 3'b110,
            S_DONE    = 3'b111;
            

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

logic [2:0] n_state;
logic [2:0] p_state;

logic en_cnt2;
logic pl_cnt2;
logic co2;

logic en_cnt1;
logic co1;

// Detect posedge of start pulse
logic start_pe;
logic start_r;


////////////////////////////////////////////////////////////////
//////////////////////   Instantiations   //////////////////////
////////////////////////////////////////////////////////////////

counter_1 counter_1 (
    .Clk(Clk),
    .Rst(Rst),
    .Start_Pe(start_pe),
    .En_Cnt1(en_cnt1),
    .Cnt1_Out(Cnt1_Out),
    .CO1(co1)
);

counter_2 counter_2 (
    .Clk(Clk),
    .Rst(Rst),
    .Start_Pe(start_pe),
    .En_Cnt2(en_cnt2),
    .Pl_Cnt2(pl_cnt2),
    .Cnt1_Out(Cnt1_Out),
    .Cnt2_Out(Cnt2_Out),
    .CO2(co2)
);

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

// State Machine
always_comb begin
  Done = '0;
  en_cnt1 = '0;
  en_cnt2 = '0;
  pl_cnt2 = '0;
  Sel_AMux = '0;
  Sel_DMux = '0;
  Sel_Mux = '0;
  Read_Reg = '0;
  Write_Reg = '0;
  Load_Temp = '0;
  Load_Min = '0;
  
  casez(p_state)
    S_IDLE: begin
      Done = 1'b0;
      if (Start == 1'b1) begin
        n_state = S_START;
      end
      else begin
        n_state = S_IDLE;
      end
    end
    S_START: begin
      if (Start == 1'b0) begin
        n_state = S_INIT;
      end
      else begin
        n_state = S_START;
      end
    end
    S_INIT: begin
      en_cnt2   = 1'b1;
      pl_cnt2   = 1'b1;
      Load_Min  = 1'b1;
      Read_Reg  = 1'b1;
      Sel_AMux  = 2'b00;
      Sel_Mux   = 1'b0;
      
      n_state = S_FIND;
    end
    S_FIND: begin
      en_cnt2   = 1'b1;
      Sel_AMux  = 2'b01;
      Read_Reg  = 1'b1;
      Sel_Mux   = 1'b1;
    
      if (co2 == 1'b1) begin
        n_state = S_UPDATE0;
      end
      else begin
        n_state = S_FIND;
      end
    end
    S_UPDATE0: begin
      Sel_AMux  = 2'b00;
      Load_Temp = 1'b1;
      Read_Reg  = 1'b1;
      
      n_state = S_UPDATE1;
    end
    S_UPDATE1: begin
      Sel_AMux = 2'b00;
      Sel_DMux = 1'b0;
      Write_Reg = 1'b1;
      en_cnt1 = 1'b1;
      
      n_state = S_UPDATE2;
    end
    S_UPDATE2: begin
      Sel_AMux = 2'b10;
      Sel_DMux = 1'b1;
      Write_Reg = 1'b1;
      
      if (co1 == 1'b1) begin
        n_state = S_DONE;
      end
      else begin
        n_state = S_INIT;
      end
    end
    S_DONE: begin
      Done = 1'b1;
      n_state = S_IDLE;
    end
  endcase
end

always_ff @(posedge Clk or posedge Rst) begin
  if (Rst) begin
    p_state <= S_IDLE;
  end
  else begin
    p_state <= n_state;
  end
end

assign Z = p_state;

// Generate posedge of start pulse
always_ff @(posedge Clk or posedge Rst) begin
  if (Rst) begin
    start_r <= '0;
  end
  else begin
    start_r <= Start;
  end
end

assign start_pe = (!start_r && Start) ? 1'b1 : 1'b0;

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
ssc_controller ssc_controller (
  .Clk(),
  .Rst(),
  .Start(),
  .Done(),
  .Cnt1_Out(),
  .Cnt2_Out(),
  .Sel_AMux(),
  .Sel_DMux(),
  .Sel_Mux(),
  .Read_Reg(),
  .Write_Reg(),
  .Load_Min(),
  .Load_Temp()
);
*/
endmodule