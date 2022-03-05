// Author : Manoj Kumar G

// This is the Tensorcore accelerator top.
// This interfaces with the scalar core, receives the 
// vector instruction, scalar operands - rs1, rs2.
// Work-in-progress

module tensorcore
include tensorcore_pkg::*;
#(
) (
  input  wire logic         clk,
  input  wire logic         reset_n,
  input  wire logic         acc_req_valid_i,
  input  accelerator_req_t  acc_req_data_i,
  output logic              acc_req_ready_o,
  output logic              acc_resp_valid_o,
  output accelerator_resp_t acc_resp_data_o,
  output logic              acc_resp_ready_i
);

  localparam ACC_REQ_DATA_WIDTH = $bits(accelerator_req_t);
  localparam CMD_QUEUE_DEPTH_BITS = $clog2(CMD_QUEUE_DEPTH);

  logic [VEC_INSTR_WIDTH-1:0]    vec_instr;
  logic [31:0]                   operand_rs1, operand_rs2;
  logic                          cmd_queue_full, cmd_queue_empty;
  logic [CMD_QUEUE_DEPTH_BITS:0] cmd_queue_occupancy;

  assign vec_instr   = acc_req_data_i.instruction;
  assign operand_rs1 = acc_req_data_i.rs1;
  assign operand_rs2 = acc_req_data_i.rs2;

  fifo #(
    .DATA_WIDTH(ACC_REQ_DATA_WIDTH),
    .DEPTH(CMD_QUEUE_DEPTH)
  ) inst_cmd_queue (
    .clk(clk),
    .reset_n(reset_n),
    .push_i(acc_req_valid_i),
    .wr_data_i(acc_req_data_i),
    .pop_i(),
    .rd_data_o(),
    .full_o(cmd_queue_full),
    .empty_o(cmd_queue_empty),
    .occupancy_o(cmd_queue_occupancy)
  );

  assign acc_req_ready_o = !cmd_queue_full;

  // Accelerator Response interface
  assign acc_resp_valid_o = !cmd_queue_full;
  assign acc_resp_data_o  = 2'b00; // Resp - OK

endmodule // tensorcore
