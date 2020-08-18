`ifndef AXIL_SEQUENCER_SV
`define AXIL_SEQUENCER_SV

class axil_sequencer extends uvm_sequencer#(axil_frame);

    `uvm_component_utils(axil_sequencer)

    function new(string name = "axil_sequencer", uvm_component parent = null);
        super.new(name,parent);
    endfunction

endclass : axil_sequencer

`endif

