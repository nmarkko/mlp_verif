`ifndef AXIS_SEQ_SV
`define AXIS_SEQ_SV

class axis_seq extends axis_base_seq;

   `uvm_object_utils (axis_seq)
   int i = 1;   
   function new(string name = "axis_seq");
       super.new(name);
   endfunction

   virtual task body();
      `uvm_info(get_type_name(), $sformatf("Sequence starting..."), UVM_HIGH)
      for (image = 0; image < 10; image ++)
      begin
         `uvm_info(get_type_name(), $sformatf("Sending image number %d.",image), UVM_HIGH);
         req=axis_frame::type_id::create("req");
         start_item(req);
         for (i = 0; i < IMG_LEN; i ++)
            req.dataQ.push_back (yQ [image * 784 + i]);
         finish_item(req);

		
         for (int layer = 1; layer < 3; layer ++)
         begin

            `uvm_info(get_type_name(), $sformatf("Layer number %d calculating",layer), UVM_NONE);
            for (int neuron = 0; neuron < neuron_array[layer]; neuron++)
            begin
               //send weights
               req=axis_frame::type_id::create("req");
               start_item(req);
               for(i=0; i<neuron_array[layer - 1]; i++)
                  req.dataQ.push_back(weightQ[layer-1][neuron*neuron_array[layer-1] + i]);
               finish_item(req);

               //send bias
               req=axis_frame::type_id::create("req");
               start_item(req);
               req.dataQ.push_back(biasQ[layer-1][neuron]);
               finish_item(req);
            end
         end
      end  
    endtask : body 

endclass : axis_seq

`endif

