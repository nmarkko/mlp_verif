`ifndef SCOREBOARD_SV
 `define SCOREBOARD_SV
`uvm_analysis_imp_decl(_axis)
`uvm_analysis_imp_decl(_axil)
class scoreboard extends uvm_scoreboard;
   
   localparam bit[9:0] neuron_array[0:2] = {10'd784, 10'd30, 10'd10};
   localparam bit[9:0] IMG_LEN = 10'd784; 
   // control fileds
   bit checks_enable = 1;
   bit coverage_enable = 1;
   bit res_ready = 0;
   bit[3:0] result =0;
   int img=0;
   int layer=1;
   int neuron=0;
   int is_bias=0;
   logic[17 : 0] yQ[$];
   logic[17 : 0] weightQ[2][$];
   logic[17 : 0] biasQ[2][$];

   int num_of_assertions = 0;   
   // This TLM port is used to connect the scoreboard to the monitor
   uvm_analysis_imp_axis#(axis_frame, scoreboard) port_axis;
   uvm_analysis_imp_axil#(axil_frame, scoreboard) port_axil;

   int num_of_tr;
   logic [31:0] reference_model_image [784];   
   `uvm_component_utils_begin(scoreboard)
      `uvm_field_int(checks_enable, UVM_DEFAULT)
      `uvm_field_int(coverage_enable, UVM_DEFAULT)
   `uvm_component_utils_end

   function new(string name = "scoreboard", uvm_component parent = null);
      super.new(name,parent);
      port_axis = new("port_axis", this);
      port_axil = new("port_axil", this);
   endfunction : new
   
   function void report_phase(uvm_phase phase);
      `uvm_info(get_type_name(), $sformatf("MLP scoreboard examined: %0d transactions", num_of_tr), UVM_LOW);
      `uvm_info(get_type_name(), $sformatf("Number of mismatch assertions for DUT is: %0d ", num_of_assertions), UVM_NONE);
      
   endfunction : report_phase
 

   function write_axis (axis_frame tr);
      if(checks_enable) 
      begin
         if(img==0)
         begin
            clear_queues();
            img=1;
            foreach(tr.dataQ[i])
               yQ.push_back(tr.dataQ[i]);
         end
         else
		 begin
				if (is_bias == 0)
				begin
					foreach(tr.dataQ[i])
						weightQ[layer-1].push_back(tr.dataQ[i]);
					is_bias = 1;
				end
				else begin
					//`uvm_info(get_type_name(), $sformatf("DEBUG neuron # %d",neuron), UVM_LOW);
					biasQ[layer-1].push_back(tr.dataQ[0]);
					neuron ++;
					is_bias = 0;
					if (neuron == neuron_array[layer])
					begin
						layer++;
						neuron = 0;
						if (layer == 3)
						 begin
							`uvm_info(get_type_name(), $sformatf("Finished classifying img"), UVM_LOW);
							calc_res();
							`uvm_info(get_type_name(), $sformatf("Classified number is: %d",result), UVM_LOW);
							img = 0;
							layer = 1;
						 end
					end
				end
			
		 end
      end
   endfunction : write_axis

   function write_axil (axil_frame tr);
      if(checks_enable) begin
         if(tr.address==4 && tr.data==1)
         begin
            res_ready=1;
         end
         else if(tr.address==12 && res_ready)
         begin
            res_ready=0;
            assert(tr.data==result)
            else 
            begin
               `uvm_error(get_type_name(), $sformatf("res mismatch, reference model: %d \t mlp: %d", result, tr.data));
               num_of_assertions++;               
            end
         end
      end
   endfunction : write_axil


   function void clear_queues ();
      yQ={};
      for(int l=0; l<2; l++)
      begin
         weightQ[l]={};
         biasQ[l]={};   
      end
   endfunction

   function void calc_res ();

      bit [27 : 0] acc=0;
	  bit [35 : 0] acc_tmp=0;	
	  bit [43 : 0] res_tmp=0;
	  bit [17:0] bias_tmp = 0;
	  bit [17 : 0] imageQ[$];
	  bit [17 : 0] resQ [30];
      bit [17 : 0] max_res=0;
      bit [3  : 0] cl_num=0;
	
      	

	  foreach(yQ[i])
		  imageQ.push_back(yQ[i]);
		  
      for(int j=0; j<30; j++)
         resQ[j]=0;

      for(int layer = 1; layer < 3; layer++)
      begin
		//resQ = {};
		for(int j=0; j<30; j++)
         resQ[j]=0;
		 
        for( int neuron=0; neuron<neuron_array[layer]; neuron++)
         begin
			acc=0;
            for( int i=0; i<neuron_array[layer-1]; i++)
            begin
               acc_tmp=( $signed(imageQ[i]) * $signed( weightQ[layer - 1][neuron * neuron_array[layer-1] + i]));
               acc = $signed(acc) + $signed (acc_tmp[31:14]);
            end
            //bias
            bias_tmp=biasQ[layer-1][neuron];
            acc=$signed(acc)+$signed(bias_tmp);
			if($signed(acc) < 0 )
			begin
				res_tmp = $signed(acc)*$signed(16'h0001);
				acc = res_tmp[39:12];
			end
			resQ[neuron] = acc [17:0];
         end
		 imageQ = {};
		 for(int j=0; j<30; j++)
			imageQ.push_back (resQ[j]);
		 
      end

      //find best result
      max_res = resQ[0];
      cl_num = 0;
      `uvm_info(get_type_name(), $sformatf("Res for neuron 0 is: %h", resQ[0]), UVM_MEDIUM);
      for(int i = 1; i < 10; i ++)
      begin
         `uvm_info(get_type_name(), $sformatf("Res for neuron %d is: %h", i, resQ[i]), UVM_MEDIUM);
         if( $signed(max_res) < $signed(resQ[i]))
         begin
            max_res = resQ[i];
            cl_num = i;
         end
      end
	   `uvm_info(get_type_name(), $sformatf("New cl_num: %d",cl_num), UVM_LOW);
	   imageQ = {};

      //finished
      result = cl_num;
   endfunction

endclass : scoreboard

`endif

