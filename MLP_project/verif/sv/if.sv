`ifndef MLP_IF_SV
 `define MLP_IF_SV
parameter integer WIDTH = 16;
parameter integer ADDRESS  = 4;   		
parameter integer C_S_AXI_DATA_WIDTH	= 32;
parameter integer C_S_AXI_ADDR_WIDTH	= 4;
parameter integer C_S_AXIS_TDATA_WIDTH	= 32;
interface axil_if (input clk, logic rst);
   // Ports of Axi Slave Bus Interface S_AXI
   
   logic [C_S_AXI_ADDR_WIDTH-1 : 0] s_axi_awaddr ;
   logic [2 : 0]                      s_axi_awprot ;
   logic                              s_axi_awvalid ;
   logic                              s_axi_awready;
   logic [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_wdata ;
   logic [(C_S_AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb = 4'b1111;
   logic                                  s_axi_wvalid ;
   logic                                  s_axi_wready;
   logic [1 : 0]                          s_axi_bresp;
   logic                                  s_axi_bvalid;
   logic                                  s_axi_bready ;
   logic [C_S_AXI_ADDR_WIDTH-1 : 0]     s_axi_araddr ;
   logic [2 : 0]                          s_axi_arprot ;
   logic                                  s_axi_arvalid ;
   logic                                  s_axi_arready;
   logic [C_S_AXI_DATA_WIDTH-1 : 0]     s_axi_rdata;
   logic [1 : 0]                          s_axi_rresp;
   logic                                  s_axi_rvalid;
   logic                                  s_axi_rready ;
   
endinterface : axil_if


interface axis_if (input clk, logic rst);
   // Ports of Axi Slave Bus Interface S_AXIS
   logic [C_S_AXIS_TDATA_WIDTH-1 : 0]     s_axis_tdata;
   logic [(C_S_AXIS_TDATA_WIDTH/8)-1 : 0] s_axis_tstrb;
   logic                                  s_axis_aclk;
   logic                                  s_axis_aresetn;
   logic                                  s_axis_tready;
   logic                                  s_axis_tlast;
   logic                                  s_axis_tvalid;
   
endinterface : axis_if


`endif

