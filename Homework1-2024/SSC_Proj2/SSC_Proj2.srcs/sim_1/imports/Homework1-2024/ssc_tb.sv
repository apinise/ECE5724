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
logic [7:0]  debug_addr;
logic        debug_en;

ssc_wrapper DUT (
  .Clk(clk),
  .Rst(rst),
  .Debug_Addr(debug_addr),
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
  test_pass <= 1'b1;
  run1 <= 1'b1;
  run2 <= 1'b1;
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
  start <= '1;
  @(posedge clk);
  start <= '0;
  wait (done == 1'b1);
  @(posedge clk);
  debug_en <= 1'b1;
  for (int k=1; k <255; k++) begin
    debug_addr <= k;
    @(posedge clk);
    read_data_r <= read_data;
    debug_addr <= k-1;
    @(posedge clk);
    $display("Current %d Previous %d OK %b", read_data, read_data_r, (read_data < read_data_r));
    run1 = (read_data < read_data_r);
  end
  
  if (run1)
	  $display("RUN 1 PASSES");
	else
	  $display("RUN 1 FAILS");
  
  @(posedge clk);
  start <= '1;
  @(posedge clk);
  start <= '0;
  wait (done == 1'b1);
  @(posedge clk);
  debug_en <= 1'b1;
  for (int k=1; k <255; k++) begin
    debug_addr <= k;
    @(posedge clk);
    read_data_r <= read_data;
    debug_addr <= k-1;
    @(posedge clk);
    $display("Current %d Previous %d OK %b", read_data, read_data_r, (read_data < read_data_r));
    run2 = (read_data < read_data_r);
  end
  
  if (run2)
	  $display("RUN 2 PASSES");
	else
	  $display("RUN 2 FAILS");
  
  test_pass = (run1 && run2);
  
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