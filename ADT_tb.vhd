Library IEEE;
use IEEE.Std_Logic_1164.All;
--Explanation: 
--The address is set, so for each read, put the address in and assert STB, 
--then grab data from D_Out and concatenate on to Data out 2 bytes

entity ADT_tst is
end entity;

architecture Behavioral of ADT_tst is
    
    constant divisor_tst : positive := 25;
    
    signal clk_tst          : std_logic;
    signal Start_tst        : std_logic;
    signal Reset_tst        : std_logic;
    signal Data_Out_tst     : std_logic_vector(15 downto 0);
    
    signal srst_tst         : std_logic;
    signal stb_i_tst        : std_logic;
    signal msg_i_tst        : std_logic;
    signal a_i_tst          : std_logic_vector(7 downto 0);
    signal d_i_tst          : std_logic_vector(7 downto 0);
    signal done_o_tst       : std_logic;
    signal err_o_tst        : std_logic;
    signal d_o_tst          : std_logic_vector(7 downto 0);
    
    signal SDA_tst          : std_logic;
    signal SCL_tst          : std_logic;

begin
            
    Clock_Div_Instance : entity work.Clock_divider(Simple)
        generic map (divisor => divisor_tst)
        
        port map (clk => clk_tst,
                  sclk => Start_tst
        );

    FSM_Instance : entity work.ADT_FSM(Behavioral)
        port map (CLK => clk_tst,
                  Start => Start_tst,
                  Reset => Reset_tst,
                  Data_out => Data_Out_tst,
                  SRST => srst_tst,
                  STB => stb_i_tst,
                  MSG => msg_i_tst,
                  A_In => a_i_tst,
                  D_In => d_i_tst,
                  Done => done_o_tst,
                  Err => err_o_tst,
                  D_Out => d_o_tst
        );

    TWICtr_Instance : entity work.TWICtl(Behavioral)
        generic map (CLOCKFREQ => 100)
        
        port map (CLK => clk_tst,
                  SRST => SRST_tst,
                  STB_I => stb_i_tst,
                  MSG_I => msg_i_tst,
                  A_I => a_i_tst,
                  D_I => d_i_tst,
                  DONE_O => done_o_tst,
                  ERR_O => err_o_tst,
                  D_O => d_o_tst,
                  SDA => SDA_tst,
                  SCL => SCL_tst
        );


    
end architecture behavioral;