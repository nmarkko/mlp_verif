`ifndef VERIF_PKG_SV
 `define VERIF_PKG_SV

package verif_pkg;

 import uvm_pkg::*;            // import the UVM library
 `include "uvm_macros.svh"     // Include the UVM macros
   
 `include "mlp_config.sv"
  `include "seq_items/axil_frame.sv"
 `include "seq_items/axis_frame.sv"
  `include "axil_monitor.sv"
 `include "axis_monitor.sv"
 `include "axil_driver.sv"
 `include "axis_driver.sv"

 `include "sequencers/axil_sequencer.sv"
 `include "sequencers/axis_sequencer.sv"

 `include "axil_agent.sv"
 `include "axis_agent.sv"
 `include "scoreboard.sv"
 `include "env.sv"

 `include "sequences/seq_lib.sv"
 `include "tests/test_lib.sv"

endpackage : verif_pkg

 `include "if.sv"

`endif

