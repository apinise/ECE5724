`timescale 1ns/1ps

module ssc_tb (
);

logic clk;
logic rst;
logic start;
logic done;
logic [15:0] read_data;
logic [15:0] read_data_r;
logic        test_pass;
logic        run1;
logic        run2;
logic        run3;
logic        run4;
logic [7:0]  debug_addr;
logic [15:0] debug_write;
logic        debug_we;
logic        debug_read;
logic        debug_en;

ssc_wrapper DUT (
  .Clk(clk),
  .Rst(rst),
  .Debug_Addr(debug_addr),
  .Debug_Write(debug_write),
  .Debug_We(debug_we),
  .Debug_Read(debug_read),
  .Debug_En(debug_en),
  .Start(start),
  .Done(done),
  .Read_Data(read_data)
);

initial begin
  clk <= '0;
  rst <= '1;
  start <= '0;
  debug_en <= '0;
  debug_addr <= '0;
  debug_write <= '0;
  debug_we <= '0;
  debug_read <= '0;
  test_pass <= 1'b1;
  run1 <= 1'b1;
  run2 <= 1'b1;
  run3 <= 1'b1;
  run4 <= 1'b1;
  read_data_r <= '0;
  @(posedge clk);
  @(posedge clk);
  rst <= '0;
  @(posedge clk);
  start <= '1;
  @(posedge clk);
  start <= '0;
  repeat (1000) begin
    @(posedge clk);
  end
  rst <= '1;
  @(posedge clk);
  rst <= '0;
  @(posedge clk);
  
  $display("This is Run 1: Testing a Reset mid Execution");
  
  start <= '1;
  @(posedge clk);
  start <= '0;
  wait (done == 1'b1);
  @(posedge clk);
  debug_en <= 1'b1;
  debug_read <= 1'b1;
  for (int k=1; k <255; k++) begin
    debug_addr <= k;
    @(posedge clk);
    read_data_r <= read_data;
    debug_addr <= k-1;
    @(posedge clk);
    $display("Current %d Previous %d OK %b", read_data, read_data_r, (read_data < read_data_r));
    run1 = ((read_data < read_data_r) && run1);
  end
  
  if (run1)
	  $display("RUN 1 PASSES");
	else
	  $display("RUN 1 FAILS");
  
  debug_en <= 1'b0;
  debug_read <= 1'b0;
  
  $display("This is Run 2: Testing Repeated Sorting Executions");
  
  @(posedge clk);
  start <= '1;
  @(posedge clk);
  start <= '0;
  wait (done == 1'b1);
  @(posedge clk);
  
  debug_en <= 1'b1;
  debug_read <= 1'b1;
  
  for (int k=1; k <255; k++) begin
    debug_addr <= k;
    @(posedge clk);
    read_data_r <= read_data;
    debug_addr <= k-1;
    @(posedge clk);
    $display("Current %d Previous %d OK %b", read_data, read_data_r, (read_data < read_data_r));
    run2 = ((read_data < read_data_r) && run2);
  end
  
  if (run2)
	  $display("RUN 2 PASSES");
	else
	  $display("RUN 2 FAILS");

  debug_read <= 1'b1;
  debug_addr <= 8'd127;
  @(posedge clk)
  
  $display("This is Run 3: Testing Read and Write at the Same Time");
  @(posedge clk);
  debug_addr <= 8'd128;
  $display("Address %h Read_Data %h Write_Data %h Read %b Write %b", debug_addr, read_data, debug_write, debug_read, debug_we);
  @(posedge clk);
  debug_addr <= 8'd127;
  debug_we <= 1'b1;
  debug_write <= 16'hffff;
  $display("Address %h Read_Data %h Write_Data %h Read %b Write %b", debug_addr, read_data, debug_write, debug_read, debug_we);
  @(posedge clk);
  debug_we <= 1'b0;
  $display("Address %h Read_Data %h Write_Data %h Read %b Write %b", debug_addr, read_data, debug_write, debug_read, debug_we);
  @(posedge clk); 
  debug_addr <= 8'd127;
  @(posedge clk);
  $display("Address %h Read_Data %h Write_Data %h Read %b Write %b", debug_addr, read_data, debug_write, debug_read, debug_we);
  
  run3 = (read_data != debug_write) ? 1'b1 : 1'b0;
  
  if (run3)
	  $display("RUN 3 PASSES");
    else
      $display("RUN 3 FAILS"); 
  
  run4 = (run1 && run2);
  
  test_pass = (run1 && run2 && run3 && run4);
  
  $display("This is Test 4: Verifying Previous Runs to Determine if Buffer is Sorted Properly");
  if (run1)
	  $display("RUN 1 PASSES");
    else
      $display("RUN 1 FAILS"); 
  
  if (run2)
	  $display("RUN 2 PASSES");
    else
      $display("RUN 2 FAILS"); 
      
  if (run3)
	  $display("RUN 3 PASSES");
    else
      $display("RUN 3 FAILS"); 
      
  if (run4)
	  $display("RUN 4 PASSES");
    else
      $display("RUN 4 FAILS"); 
    
  if (test_pass)
	  $display("TESTBENCH PASSES");
	else
	  $display("TESTBENCH FAILS"); 
  
  $finish;
end

always begin
  #5;
  clk <= ~clk;
end

endmodule