`ifndef AXIS_BASE_SEQ_SV
`define AXIS_BASE_SEQ_SV

class axis_base_seq extends uvm_sequence#(axis_frame);

   `uvm_object_utils(axis_base_seq)

   // PARAMETERS
   localparam bit[9:0] neuron_array[0:2] = {10'd784, 10'd30, 10'd10};
   localparam bit[9:0] IMG_LEN = 10'd784; 
   localparam DATA_WIDTH = 18;
   `uvm_declare_p_sequencer(axis_sequencer)

   string y_dir = "..\/..\/MLP_data";
   string weight_dir = "..\/..\/MLP_data";
   string bias_dir = "..\/..\/MLP_data";

   logic[DATA_WIDTH - 1 : 0] yQ[$];
   logic[DATA_WIDTH - 1 : 0] weightQ[2][$]; // 3 layers - 1 input layer = 2
   logic[DATA_WIDTH - 1 : 0] biasQ[2][$];
   

   logic[DATA_WIDTH - 1 : 0] tmp;
   int i=0;
   int num=0;
   int fd=0;
   string s="";
   
   int image=0;

   function new(string name = "axis_base_seq");
      super.new(name);
      extract_data();
   endfunction

   // objections are raised in pre_body
   virtual task pre_body();
      uvm_phase phase = get_starting_phase();
      if (phase != null)
          phase.raise_objection(this, {"Running sequence '", get_full_name(), "'"});
   endtask : pre_body 

   // objections are dropped in post_body
   virtual task post_body();
      uvm_phase phase = get_starting_phase();
      if (phase != null)
          phase.drop_objection(this, {"Completed sequence '", get_full_name(), "'"});
   endtask : post_body

   function void extract_data();
      //CLEAR QUEUES, EXTRACT DATA FROM FILES
      while(yQ.size()!=0)
      yQ.delete(0);

      for(int c=0; c<2; c++)
      begin
         while(biasQ[c].size()!=0)
            biasQ[c].delete(0);
         while(biasQ[c].size()!=0)   
            weightQ[c].delete(0);   
      end

      //EXTRACTING TEST IMAGE [y]
      fd = ($fopen({y_dir,"/\input_images.txt"}, "r"));
      if(fd)
      begin
         `uvm_info(get_name(),$sformatf("test images opened successfully"),UVM_HIGH);

         while(!$feof(fd))
         begin
			   if (i >= 784)
			   begin
					num++;
					i=0;
			   end
               $fscanf(fd ,"%b\n",tmp);
               yQ.push_back(tmp);
               i++;
			   
         end
         `uvm_info(get_name(),$sformatf("Num of images in queue is: %d",num),UVM_HIGH);
      end
      else
        `uvm_info(get_name(),$sformatf("Error opening test images file"),UVM_HIGH);
        num=0;
      $fclose(fd);

      //EXTRACTING WEIGHTS
      for (int x=1; x<3; x++)
      begin
         s.itoa(x);
         fd = ($fopen({weight_dir,"/\weights",s,".txt"}, "r"));
         if(fd)
         begin
            `uvm_info(get_name(),$sformatf("weights%d opened successfully",x),UVM_HIGH);
            while(!$feof(fd))
            begin
                $fscanf(fd ,"%b\n",tmp);
                weightQ[x-1].push_back(tmp);
            end
            //`uvm_info(get_name(),$sformatf("Num of weights in layer %d in queue is: %d",x,num),UVM_HIGH);
         end
         else
           `uvm_info(get_name(),$sformatf("Error opening %d. weights file",x),UVM_HIGH);
         $fclose(fd);
      end

      //EXTRACTING BIASES
      for (int x=1; x<3; x++)
      begin
         s.itoa(x);
         fd = ($fopen({bias_dir,"/\biases",s,".txt"}, "r"));
         if(fd)
         begin
            `uvm_info(get_name(),$sformatf("biases%d opened successfully",x),UVM_HIGH);
            while(!$feof(fd))
            begin
                  $fscanf(fd ,"%b\n",tmp);
                  biasQ[x-1].push_back(tmp);
                  num++;
            end
            `uvm_info(get_name(),$sformatf("Num of biases for layer %d in queue is: %d",x,num),UVM_HIGH);
         end
         
         else
           `uvm_info(get_name(),$sformatf("Error opening %d. biases file",x),UVM_HIGH);
           num=0;
         $fclose(fd);
      end
	  
    endfunction

endclass : axis_base_seq

`endif

