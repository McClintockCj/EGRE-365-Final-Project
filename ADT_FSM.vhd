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
          A_In : out std_logic_vector(7 downto 0) := b"00000000";
          D_In : out std_logic_vector(7 downto 0);
          Done : in std_logic;
          Err : in std_logic;
          D_Out : in std_logic_vector(7 downto 0));
          
end entity;

architecture Behavioral of ADT_FSM is
    
    Type states is (idle, read_request, send_pulse1, save_MSB, send_pulse2, save_LSB);
    signal current_state, next_state : states;

begin
    
    state_register : process(clk)
    begin
        if (reset = '1') then
            current_state <= idle;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process state_register;
    
    Next_State_Logic : process(current_state, start) is
    begin
    
        case current_state is
            when idle =>
                if rising_edge(start) then
                    next_state <= read_request;
                else
                    next_state <= idle;
                end if;
            
       
       
       
        end case;

       
    end process Next_State_Logic;
    
    
    
    Output_Logic : process(current_state)
        begin
       
    end process Output_Logic;
    
end architecture behavioral;