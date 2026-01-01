`timescale 1ns/1ps

module tb_fifo;

  // ---------------------------------
  // Signals
  // ---------------------------------
  reg         clk;
  reg         rst;
  reg         wr_en;
  reg         rd_en;
  reg [7:0]   din;

  wire [7:0]  dout;
  wire        full;
  wire        empty;

  // ---------------------------------
  // Reference model
  // ---------------------------------
  reg [7:0] exp_mem [0:15];
  integer   wptr;
  integer   rptr;

  // ---------------------------------
  // Clock: 10 ns
  // ---------------------------------
  always #5 clk = ~clk;

  // ---------------------------------
  // DUT
  // ---------------------------------
  fifo_generator_0 dut (
    .clk   (clk),
    .srst  (rst),
    .din   (din),
    .wr_en (wr_en),
    .rd_en (rd_en),
    .dout  (dout),
    .full  (full),
    .empty (empty)
  );

  // ---------------------------------
  // Test
  // ---------------------------------
  initial begin
    // Init
    clk   = 0;
    rst   = 1;
    wr_en = 0;
    rd_en = 0;
    din   = 8'd0;
    wptr  = 0;
    rptr  = 0;

    // -------------------------------
    // SYNCHRONOUS RESET
    // -------------------------------
    repeat (5) @(posedge clk);
    rst <= 0;
    @(posedge clk);

    if (empty !== 1'b1 || full !== 1'b0)
      $fatal("RESET FAILED: empty=%b full=%b", empty, full);

    $display("RESET CHECK PASSED");

    // -------------------------------
    // WRITE PHASE
    // -------------------------------
    repeat (4) begin
      @(posedge clk);
      if (full)
        $fatal("FIFO FULL TOO EARLY");

      wr_en <= 1;
      din   <= wptr + 1;

      exp_mem[wptr] = wptr + 1;
      wptr = wptr + 1;
    end

    @(posedge clk);
    wr_en <= 0;

    // -------------------------------
    // READ PHASE (latency = 1)
    // -------------------------------
    repeat (4) begin
      @(posedge clk);
      if (empty)
        $fatal("FIFO EMPTY TOO EARLY");

      rd_en <= 1;

      @(posedge clk);   // latency cycle
      rd_en <= 0;

      if (dout !== exp_mem[rptr])
        $fatal("DATA MISMATCH: exp=%0h got=%0h", exp_mem[rptr], dout);

      rptr = rptr + 1;
    end

    // -------------------------------
    // FINAL EMPTY CHECK
    // -------------------------------
    @(posedge clk);
    if (empty !== 1'b1)
      $fatal("FIFO NOT EMPTY AFTER READS");

    // -------------------------------
    // PASS
    // -------------------------------
    $display("====================================");
    $display(" FIFO BASIC FUNCTIONAL VERIFICATION PASSED ");
    $display("====================================");

    #20 $finish;
  end

endmodule
