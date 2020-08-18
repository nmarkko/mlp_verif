`ifndef AXIL_AGENT_SV
 `define AXIL_AGENT_SV

class axil_agent extends uvm_agent;

   // components
   axil_driver axil_drv;
   axil_monitor axil_mon;
   axil_sequencer axil_seqr;
   
   `uvm_component_utils_begin (axil_agent)
   `uvm_component_utils_end

   function new(string name = "axil_agent", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      axil_drv = axil_driver::type_id::create("axil_drv", this);
      axil_seqr = axil_sequencer::type_id::create("axil_seqr", this);
      axil_mon = axil_monitor::type_id::create("axil_monitor", this);
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      axil_drv.seq_item_port.connect(axil_seqr.seq_item_export);      
   endfunction : connect_phase

endclass : axil_agent

`endif

