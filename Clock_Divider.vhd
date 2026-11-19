Library IEEE;
use IEEE.Std_Logic_1164.All;


entity Clock_divider is 
    generic (divisor : positive);                           --Divisor to count up to

    port (clk       : in std_logic;                         --Input clock and outputs
          sclk      : out std_logic                         --slowed down clock
    );
end entity;

architecture Simple of Clock_divider is

    signal sclk_shell : std_logic := '0';                   --Shell signal for slow clock

begin

    clk_div : process(clk)

        variable count : integer range 0 to divisor := 0;   --Declare count variable
        
    begin
    
        if rising_edge(clk) then
            if (count = divisor - 1) then                   --Each rising fast clk edge
                sclk_shell <= not sclk_shell;               --increment count by 1, and
                count := 0;                                 --when count reaches the divisor
            else                                            --reset count and swap the value
                count := count + 1;                         --of slow clock (rising/falling
            end if;                                         --edge)
        end if;
    end process clk_div;
    
    sclk <= sclk_shell;                                     --Update real clock output
    
end architecture Simple;