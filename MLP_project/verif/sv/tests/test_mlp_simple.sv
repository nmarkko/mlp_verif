`ifndef TEST_MLP_SIMPLE_SV
 `define TEST_MLP_SIMPLE_SV

class test_mlp_simple extends test_base;

   `uvm_component_utils(test_mlp_simple)

   axil_seq mlp_axil_seq;
   axis_seq mlp_axis_seq;
   

   function new(string name = "test_mlp_simple", uvm_component parent = null);
      super.new(name,parent);
   endfunction : new
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mlp_axil_seq = axil_seq::type_id::create("mlp_axil_seq");
      mlp_axis_seq = axis_seq::type_id::create("mlp_axis_seq");

   endfunction : build_phase

   task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      phase.phase_done.set_drain_time(this, 1000);
	if(1==1) begin
	  fork
		mlp_axis_seq.start(mlp_env.mlp_axis_agent.axis_seqr);
		mlp_axil_seq.start(mlp_env.mlp_axil_agent.axil_seqr);
	  join_any
	 end
      
      phase.drop_objection(this);
   endtask : run_phase

endclass : test_mlp_simple

`endif

