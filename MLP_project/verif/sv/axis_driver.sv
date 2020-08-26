`ifndef AXIS_DRIVER_SV
 `define AXIS_DRIVER_SV
 
`uvm_analysis_imp_decl(_classification_done)
class axis_driver extends uvm_driver#(axis_frame);

   `uvm_component_utils(axis_driver)
   uvm_analysis_imp_classification_done #(axil_frame, axis_driver) port_classification_done;
   // The virtual interface used to drive and view HDL signals.
   virtual interface axis_if vif;
   bit classif_done = 0;
   int j = 0;

   function new(string name = "axis_driver", uvm_component parent = null);
      super.new(name,parent);
	  port_classification_done = new("port_classification_done", this);
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      if (!uvm_config_db#(virtual axis_if)::get(this, "*", "axis_if", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"})
   endfunction : connect_phase

   task run_phase(uvm_phase phase);
      forever 
      begin
         //@(posedge vif.clk)
         //`uvm_info(get_type_name(), $sformatf("Driver starting..."), UVM_HIGH)
		 //while(!classif_done)
         //begin
			 @(negedge vif.clk);
			 vif.s_axis_tlast=0;
			 vif.s_axis_tvalid=0;
		 //end
		 //classif_done = 0;
		 
		 //for (j = 0; j < 81; j++)
		 //begin
			 seq_item_port.get_next_item(req);
			 //`uvm_info(get_type_name(), $sformatf("Driver sending...\n%s", req.sprint()), UVM_HIGH)
			 // do actual driving here
			 foreach (req.dataQ[i])
			 begin
				#1 if(i==(req.dataQ.size-1))
				   vif.s_axis_tlast=1;
				else
				   vif.s_axis_tlast=0;

				vif.s_axis_tvalid=1;
				vif.s_axis_tdata=req.dataQ[i];
				@(posedge vif.clk iff vif.s_axis_tready);
			 end
			 seq_item_port.item_done();
		 //end
      end
   endtask : run_phase
   
   
   function write_classification_done (axil_frame tr);
      //`uvm_info(get_type_name(), $sformatf("CLASSIFICATION DONE"), UVM_HIGH)      
      if ( (tr.address == 4) && (tr.data == 1))
	  begin
		classif_done = 1;
	  end
   endfunction : write_classification_done
   
endclass : axis_driver

`endif

