`ifndef ENV_SV
 `define ENV_SV

class env extends uvm_env;

   axil_agent mlp_axil_agent;
   axis_agent mlp_axis_agent;
   scoreboard scbd;
   mlp_config cfg;

   
   `uvm_component_utils (env)

   function new(string name = "env", uvm_component parent = null);
      super.new(name,parent);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mlp_axis_agent = axis_agent::type_id::create("mlp_axis_agent", this);
      mlp_axil_agent = axil_agent::type_id::create("mlp_axil_agent", this);
      scbd = scoreboard::type_id::create("scbd", this);
      if(!uvm_config_db#(mlp_config)::get(this, "", "mlp_config", cfg))
        `uvm_fatal("NOCONFIG",{"Config object must be set for: ",get_full_name(),".cfg"})
   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      mlp_axil_agent.axil_mon.item_collected_port.connect(scbd.port_axil);
      mlp_axis_agent.axis_mon.item_collected_port.connect(scbd.port_axis);
	  mlp_axil_agent.axil_mon.item_collected_port.connect(mlp_axis_agent.axis_drv.port_classification_done);
      
   endfunction : connect_phase

endclass : env

`endif


