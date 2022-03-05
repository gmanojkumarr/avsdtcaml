// Author : Manoj Kumar G

// This is a generic parameterised FIFO design module

module fifo #(
  parameter DATA_WIDTH = 32,
  parameter DEPTH = 4
) (
  input wire logic                  clk,
  input wire logic                  reset_n,
  input wire logic                  push_i,
  input wire logic [DATA_WIDTH-1:0] wr_data_i,
  input wire logic                  pop_i,
  output logic [DATA_WIDTH-1:0]     rd_data_o,
  output logic                      full_o,
  output logic                      empty_o,
  output logic [$clog2(DEPTH):0]    occupancy_o
);

  localparam PTR_WIDTH = $clog2(DEPTH);

  logic [PTR_WIDTH-1:0]  rd_ptr, wr_ptr, next_rd_ptr, next_wr_ptr;
  logic                  push_valid, pop_valid;
  logic                  full, empty;
  logic                  fifo_count_en;
  logic [PTR_WIDTH-1:0]  fifo_count, next_fifo_count;
  logic [DATA_WIDTH-1:0] fifo_mem[0:DEPTH-1];
  logic [DATA_WIDTH-1:0] rd_data, next_rd_data;

  assign full  = (fifo_count == DEPTH);
  assign empty = (fifo_count == '0);
  assign push_valid = push_i && !full;
  assign pop_valid  = pop_i && !empty;

  always_comb begin
    next_fifo_count = '0;
    case({push_valid, pop_valid})
      2'b00 : next_fifo_count = fifo_count;
      2'b01 : next_fifo_count = fifo_count - PTR_WIDTH'd1;
      2'b10 : next_fifo_count = fifo_count + PTR_WIDTH'd1;
      2'b11 : next_fifo_count = fifo_count;
    endcase
  end // always_comb

  assign fifo_count_en = push_valid || pop_valid;

  always_ff @(posedge clk or negedge reset_n) begin
    if(~reset_n)
      fifo_count <= '0;
    else if(fifo_count_en)
      fifo_count <= next_fifo_count;
  end // always_ff

  // pointer logic
  always_comb begin
    next_rd_ptr = '0;
    next_wr_ptr = '0;
    case({push_valid, pop_valid})
      2'b00 : begin
                next_rd_ptr = rd_ptr;
                next_wr_ptr = wr_ptr;
              end
      2'b01 : begin
                next_rd_ptr = rd_ptr + PTR_WIDTH'd1;
                next_wr_ptr = wr_ptr;
              end
      2'b10 : begin
                next_rd_ptr = rd_ptr;
                next_wr_ptr = wr_ptr + PTR_WIDTH'd1;
              end
      2'b11 : begin
                next_rd_ptr = rd_ptr;
                next_wr_ptr = wr_ptr;
              end
    endcase
  end // always_comb

  always_ff @(posedge clk or negedge reset_n) begin
    if(~reset_n) begin
      rd_ptr <= '0;
      wr_ptr <= '0;
    end
    else if(fifo_count_en) begin
      rd_ptr <= next_rd_ptr;
      wr_ptr <= next_wr_ptr;
    end
  end // always_ff

  // FIFO Memory logic
  always_ff @(posedge clk) begin
    if(push_valid)
      fifo_mem[wr_ptr] <= wr_data_i;
  end // always_ff

  assign next_rd_data = fifo_mem[rd_ptr];

  always_ff @(posedge clk) begin
    if(pop_valid)
      rd_data <= next_rd_data;
  end // always_ff

  // Outputs
  assign rd_data_o   = rd_data;
  assign full_o      = full;
  assign empty_o     = empty;
  assign occupancy_o = fifo_count;


endmodule // fifo
