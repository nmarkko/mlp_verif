
module verif_top#
  (parameter integer C_S_AXI_DATA_WIDTH	= 32,
   parameter integer C_S_AXI_ADDR_WIDTH = 4,
   parameter integer C_S_AXIS_TDATA_WIDTH = 32
   )
   ();
   
   import uvm_pkg::*;            // import the UVM library
`include "uvm_macros.svh"     // Include the UVM macros

   import verif_pkg::*;
   
   logic             s_axi_aclk = 0;
   logic             s_axi_aresetn;

   // interface
   axil_if axil_vif(s_axi_aclk, s_axi_aresetn);
   axis_if axis_vif(s_axi_aclk, s_axi_aresetn);
   
   
   
   // DUT
   axi_mlp_v1_0 #
     (
      // .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
      // .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH),
      // .C_S_AXIS_TDATA_WIDTH(C_S_AXIS_TDATA_WIDTH),
      // .WIDTH(WIDTH)                
      )
   MLP_IP_inst
     (
      .s00_axi_aclk(s_axi_aclk),
      .s00_axi_aresetn(s_axi_aresetn),
      .s00_axi_awaddr(axil_vif.s_axi_awaddr),
      .s00_axi_awprot(axil_vif.s_axi_awprot),
      .s00_axi_awvalid(axil_vif.s_axi_awvalid),
      .s00_axi_awready(axil_vif.s_axi_awready),
      .s00_axi_wdata(axil_vif.s_axi_wdata),
      .s00_axi_wstrb(axil_vif.s_axi_wstrb),
      .s00_axi_wvalid(axil_vif.s_axi_wvalid),
      .s00_axi_wready(axil_vif.s_axi_wready),
      .s00_axi_bresp(axil_vif.s_axi_bresp),
      .s00_axi_bvalid(axil_vif.s_axi_bvalid),
      .s00_axi_bready(axil_vif.s_axi_bready),
      .s00_axi_araddr(axil_vif.s_axi_araddr),
      .s00_axi_arprot(axil_vif.s_axi_arprot),
      .s00_axi_arvalid(axil_vif.s_axi_arvalid),
      .s00_axi_arready(axil_vif.s_axi_arready),
      .s00_axi_rdata(axil_vif.s_axi_rdata),
      .s00_axi_rresp(axil_vif.s_axi_rresp),
      .s00_axi_rvalid(axil_vif.s_axi_rvalid),
      .s00_axi_rready(axil_vif.s_axi_rready),
      .s00_axis_aclk(s_axi_aclk),
      .s00_axis_aresetn(s_axi_aresetn),
      .s00_axis_tready(axis_vif.s_axis_tready),
      .s00_axis_tdata(axis_vif.s_axis_tdata),
      .s00_axis_tstrb(axis_vif.s_axis_tstrb),
      .s00_axis_tlast(axis_vif.s_axis_tlast),
      .s00_axis_tvalid(axis_vif.s_axis_tvalid)
      ); 

   initial begin
      set_global_timeout(10s/1ps);
      uvm_config_db#(virtual axil_if)::set(null, "*", "axil_if", axil_vif);
      uvm_config_db#(virtual axis_if)::set(null, "*", "axis_if", axis_vif);
      run_test();
   end

   // clock and reset init.
   initial begin

      s_axi_aclk <= 0;
      s_axi_aresetn <= 0;
      #50 s_axi_aresetn <= 1;
   end

   // clock generation
   always #50 s_axi_aclk = ~s_axi_aclk;

endmodule : verif_top

