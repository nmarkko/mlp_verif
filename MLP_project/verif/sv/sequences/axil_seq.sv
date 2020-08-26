`ifndef AXIL_SEQ_SV
`define AXIL_SEQ_SV

class axil_seq extends axil_base_seq;
   int num_of_images = 0;
   int image = 0;   
    `uvm_object_utils (axil_seq)

    function new(string name = "axil_seq");
        super.new(name);
    endfunction

    virtual task body();
        // axil example - just send one item
       assert(std::randomize(num_of_images) with {num_of_images > 0; num_of_images <= 10;});
       
       `uvm_info(get_type_name(), $sformatf("%d images are being classified ",num_of_images), UVM_NONE);
       //random reading from MLP
       `uvm_do_with(req, {req.read_write == 0; req.data == 1; req.address == 4;});
       `uvm_do_with(req, {req.read_write == 0; req.data == 1; req.address == 0;});
       //start MLP
       `uvm_do_with(req, {req.read_write == 1; req.data == 1; req.address == 0;});
	   //random reading from MLP
	   `uvm_do_with(req, {req.read_write == 0; req.data == 0; req.address == 0;});
       `uvm_do_with(req, {req.read_write == 1; req.data == 0; req.address == 0;});
       `uvm_info(get_type_name(), $sformatf("image %d is being classified ",image), UVM_NONE);
       forever begin
          `uvm_do_with(req, {req.read_write == 0; req.data == 1; req.address == 4;});
          if(req.data == 1)begin
            `uvm_do_with(req, {req.read_write == 0; req.data == 1; req.address == 12;});
             image ++;             
             if(image == num_of_images)
               break;
             `uvm_info(get_type_name(), $sformatf("image number %d is being classified ",image), UVM_NONE);
             //start MLP
             `uvm_do_with(req, {req.read_write == 1; req.data == 1; req.address == 0;});
             `uvm_do_with(req, {req.read_write == 1; req.data == 0; req.address == 0;});
          end
       end

    endtask : body 

endclass : axil_seq

`endif

