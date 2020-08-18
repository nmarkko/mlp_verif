`ifndef AXIS_AGENT_SV
 `define AXIS_AGENT_SV

class axis_agent extends uvm_agent;

   // components
   axis_driver axis_drv;
   axis_monitor axis_mon;
   axis_sequencer axis_seqr;
   
   `uvm_component_utils_begin (axis_agent)
   `uvm_component_utils_end

   function new(string name = "axis_agent", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      axis_drv = axis_driver::type_id::create("axis_drv", this);
      axis_seqr = axis_sequencer::type_id::create("axis_seqr", this);
      axis_mon = axis_monitor::type_id::create("axis_monitor", this);
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      axis_drv.seq_item_port.connect(axis_seqr.seq_item_export);      
   endfunction : connect_phase

endclass : axis_agent

`endif

