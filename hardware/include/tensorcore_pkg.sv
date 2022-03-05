// Author : Manoj Kumar Ganapathineedi

// Tensorcore package

package tensorcore_pkg;

  ////////////////
  // Parameters //
  ////////////////

  // Width of the vector instruction
  localparam VEC_INSTR_WIDTH = 32;
  // Depth of the command queue between scalar core and tensorcore accelerator
  localparam CMD_QUEUE_DEPTH = 4;

  typedef struct packed {
    logic [31:0] instruction;
    logic [31:0] rs1;
    logic [31:0] rs2;
  } accelerator_req_t;
  
  typedef struct packed {
    logic [1:0] resp;
  } accelerator_resp_t;

endpackage : tensorcore_pkg
