----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2020 04:53:11 PM
-- Design Name: 
-- Module Name: mem_subsystem - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mem_subsystem is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           -- Interface to the AXI controllers
            reg_data_i : in STD_LOGIC;
            --start
            start_wr_i : in STD_LOGIC;
            start_axi_o : out STD_LOGIC;
            start_mlp_o : out STD_LOGIC;
            --ready
            ready_mlp_i : in STD_LOGIC;
            ready_axi_o : out STD_LOGIC;
            --toggle
            toggle_mlp_i : in STD_LOGIC;
            toggle_axi_o : out STD_LOGIC;
            --cl_num
            cl_num_mlp_i: in STD_LOGIC_VECTOR(3 downto 0);
            cl_num_axi_o : out STD_LOGIC_VECTOR(3 downto 0));
end mem_subsystem;

architecture Behavioral of mem_subsystem is
    signal start_s, ready_s, toggle_s: STD_LOGIC;
    signal cl_num_s: STD_LOGIC_VECTOR(3 downto 0);
begin
    start_mlp_o <= start_s;
    start_axi_o <= start_s;
    ready_axi_o <= ready_s;
    toggle_axi_o <= toggle_s;
    cl_num_axi_o <= cl_num_s;
    
   --start reg
     process(clk) 
     begin
         if clk'event and clk='1' then
             if reset = '1' then
                 start_s <= '0';
             elsif start_wr_i = '1' then
                 start_s <= reg_data_i;
             end if;
         end if;
     end process;
     
     --ready reg
     process(clk) 
     begin
         if clk'event and clk='1' then
             if reset = '1' then
                 ready_s <= '0';
             else
                 ready_s <= ready_mlp_i;
             end if;
         end if;
     end process;
     
     --toggle reg
     process(clk) 
     begin
         if clk'event and clk='1' then
             if reset = '1' then
                 toggle_s <= '0';
             else
                 toggle_s <= toggle_mlp_i;
             end if;
         end if;
     end process;
 
     --cl_num reg
     process(clk) 
     begin
         if clk'event and clk='1' then
             if reset = '1' then
                 cl_num_s <= (others => '0');
             else
                 cl_num_s <= cl_num_mlp_i;
             end if;
         end if;
     end process;      

end Behavioral;
