Library IEEE;
use IEEE.Std_Logic_1164.All;
--Explanation: 
--The address is set, so for each read, put the address in and assert STB, 
--then grab data from D_Out and concatenate on to Data out 2 bytes

entity ADT_Top_Level is
    generic (divisor : positive := 25000000);   --Use for synthesis to make "Start"
                                                --swap every 25 million clock cycles (MHz)
    
    --generic (divisor : positive := 25);       --Use for testbench simulation to make
                                                --"Start" swap every 25 clock cycles (Hz)
    
    port (signal clk          : in std_logic := '0';
          signal Reset        : in std_logic;
          signal Data_Out     : out std_logic_vector(15 downto 0);
          signal SDA          : inout std_logic;
          signal SCL          : inout std_logic
    );
end entity;

architecture Behavioral of ADT_Top_Level is

    signal start_sig        : std_logic;
    
    signal srst_sig         : std_logic;
    signal stb_i_sig        : std_logic;
    signal msg_i_sig        : std_logic;
    signal a_i_sig          : std_logic_vector(7 downto 0);
    signal d_i_sig          : std_logic_vector(7 downto 0);
    signal done_o_sig       : std_logic;
    signal err_o_sig        : std_logic;
    signal d_o_sig          : std_logic_vector(7 downto 0);


begin
    
    Clock_Div_Instance : entity work.Clock_divider(Simple)
        generic map (divisor => divisor)
        
        port map (clk => clk,
                  sclk => start_sig
        );
    
    FSM_Instance : entity work.ADT_FSM(Behavioral)
        port map (CLK => clk,
                  Start => start_sig,
                  Reset => Reset,
                  Data_out => Data_Out,
                  SRST => srst_sig,
                  STB => stb_i_sig,
                  MSG => msg_i_sig,
                  A_In => a_i_sig,
                  D_In => d_i_sig,
                  Done => done_o_sig,
                  Err => err_o_sig,
                  D_Out => d_o_sig
        );

    TWICtr_Instance : entity work.TWICtl(Behavioral)
        generic map (CLOCKFREQ => 100)
        
        port map (CLK => clk,
                  SRST => SRST_sig,
                  STB_I => stb_i_sig,
                  MSG_I => msg_i_sig,
                  A_I => a_i_sig,
                  D_I => d_i_sig,
                  DONE_O => done_o_sig,
                  ERR_O => err_o_sig,
                  D_O => d_o_sig,
                  SDA => SDA,
                  SCL => SCL
        );

end architecture behavioral;