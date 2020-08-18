`ifndef MLP_CONFIG_SV
 `define MLP_CONFIG_SV
class mlp_config extends uvm_object;

   uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  
   `uvm_object_utils_begin (mlp_config)
      `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_DEFAULT)
   `uvm_object_utils_end

   function new(string name = "mlp_config");
      super.new(name);
   endfunction

endclass : mlp_config

`endif


