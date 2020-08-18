`ifndef AXIS_SEQUENCER_SV
`define AXIS_SEQUENCER_SV

class axis_sequencer extends uvm_sequencer#(axis_frame);

    `uvm_component_utils(axis_sequencer)

    function new(string name = "axis_sequencer", uvm_component parent = null);
        super.new(name,parent);
    endfunction

endclass : axis_sequencer

`endif

