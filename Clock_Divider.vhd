Library IEEE;
use IEEE.Std_Logic_1164.All;


entity Clock_divider is 
    generic (divisor : positive);
    
    port (clk       : in std_logic;
          sclk      : out std_logic
    );
end entity;

architecture Simple of Clock_divider is

    signal sclk_shell : std_logic := '0';

begin

    clk_div : process(clk)

        variable count : integer range 0 to divisor := 0;
        
    begin
    
        if rising_edge(clk) then
            if (count = divisor - 1) then
                sclk_shell <= not sclk_shell;
                count := 0;
            else
                count := count + 1;
            end if;
        end if;
    end process clk_div;
    
    sclk <= sclk_shell;
    
end architecture Simple;