`ifndef TEST_BASE_SV
`define TEST_BASE_SV

class test_base extends uvm_test;

    env mlp_env;
    mlp_config mlp_cfg;

    `uvm_component_utils(test_base)

    function new(string name = "test_base", uvm_component parent = null);
        super.new(name,parent);
    endfunction : new
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mlp_env = env::type_id::create("mlp_env", this);
        mlp_cfg = mlp_config::type_id::create("mlp_cfg");
        uvm_config_db#(mlp_config)::set(this, "*", "mlp_config", mlp_cfg);
    endfunction : build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

endclass : test_base

`endif

