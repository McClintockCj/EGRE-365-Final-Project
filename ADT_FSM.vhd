Library IEEE;
use IEEE.Std_Logic_1164.All;
--Explanation: 
--The address is set, so for each read, put the address in and assert STB, 
--then grab data from D_Out and concatenate on to Data out 2 bytes

entity ADT_FSM is
    port (clk : in std_logic;
          Start : in std_logic;
          Reset : in std_logic;
          Data_Out : out std_logic_vector(15 downto 0);
          SRST : out std_logic;
          STB : out std_logic;
          MSG : out std_logic;
          A_In : out std_logic_vector(7 downto 0);
          D_In : out std_logic_vector(7 downto 0);
          Done : in std_logic;
          Err : in std_logic;
          D_Out : in std_logic_vector(7 downto 0));
          
end entity;

architecture Behavioral of ADT_FSM is
Type States is (IDLE);
Signal CurrState : std_logic;
Signal NextState : std_logic;
begin

Next_State_Logic : process(CurrState, Start, Reset) is
    begin
   
end process Next_State_Logic;

State_Register : process(Clk) is
    begin
    if (Rising_Edge(clk)) then
        CurrState <= NextState;
    end if;
end process State_Register;

Output_Logic : process(CurrState)
    begin
   
end process Output_Logic;

end architecture behavioral;