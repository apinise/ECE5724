`timescale 1ns/1ps

module mem_buffer (
  // Clk + Reset
  input   logic         Clk,
  input   logic         Rst,
  // Read + Write Ctrl
  input   logic         Read,
  input   logic         Write,
  // Read + Write Ports
  input   logic [7:0]   Address,
  input   logic [15:0]  Write_Data,
  output  logic [15:0]  Read_Data
);

////////////////////////////////////////////////////////////////
////////////////////////   Parameters   ////////////////////////
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
///////////////////////   Internal Net   ///////////////////////
////////////////////////////////////////////////////////////////

logic [15:0]  data_mem  [255:0];

////////////////////////////////////////////////////////////////
//////////////////////   Instantiations   //////////////////////
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
///////////////////////   Module Logic   ///////////////////////
////////////////////////////////////////////////////////////////

initial begin
  //$readmemb("C:/Users/socce/Desktop/S24/5724/ECE5724/Homework1-2024/data.txt", data_mem);
  $readmemb("C:/Users/Evan/Documents/S24/5724/ECE5724/Homework1-2024/data.txt", data_mem);
end

// Write Port
always_ff @(posedge Clk or posedge Rst) begin
  if (Rst) begin
    //$readmemb("C:/Users/Evan/Documents/S24/5724/ECE5724/Homework1-2024/data.txt", data_mem);
    data_mem[Address] <= data_mem[Address];
  end
  else begin
    if (Write && ~Read) begin
      data_mem[Address] <= Write_Data;
    end
    else begin
      data_mem[Address] <= data_mem[Address];
    end
  end
end

// Read Port
/*
always_ff @(posedge Clk or posedge Rst) begin
  if (Rst) begin
    Read_Data <= data_mem[0];
  end
  else begin
    if (Read) begin
      Read_Data <= data_mem[Address];
    end
    else begin
      Read_Data <= Read_Data;
    end
  end
end
*/

assign Read_Data = (Read && ~Write) ? data_mem[Address] : Read_Data;

////////////////////////////////////////////////////////////////
//////////////////   Instantiation Template   //////////////////
////////////////////////////////////////////////////////////////
/*
mem_buffer mem_buffer (
  .Clk(),
  .Rst(),
  .Read(),
  .Write(),
  .Address(),
  .Write_Data(),
  .Read_Data()
);
*/
endmodule