Library IEEE;
use IEEE.Std_Logic_1164.All;
--Explanation: 
--The address is set, so for each read, put the address in and assert STB, 
--then grab data from D_Out and concatenate on to Data out 2 bytes

entity ADT_FSM is
    port (clk       : in std_logic;
          Start     : in std_logic;
          Reset     : in std_logic;
          Data_Out  : out std_logic_vector(15 downto 0);
          SRST      : out std_logic;                                    --Reset signal
          STB       : out std_logic;                                    --Send "En" signal
          MSG       : out std_logic;                                    --Unused, write thing we don't need yet
          A_In      : out std_logic_vector(7 downto 0) := b"10010111";  --Component Address
          D_In      : out std_logic_vector(7 downto 0);                 --Unused, but would be bus to write data
          Done      : in std_logic;
          Err       : in std_logic := '0';
          D_Out     : in std_logic_vector(7 downto 0));
          
end entity;

architecture Behavioral of ADT_FSM is
    
    Type states is (idle, read_MSB, wait_done_low, read_LSB, send_temp_out);        --States
    signal current_state, next_state : states;
    
    signal start_prev, start_edge : std_logic := '0';                               --Mimics rising_edge(Start) check
    signal MSB_shell, LSB_shell : std_logic_vector(7 downto 0) := (others => '0');  --Shell signals to hold MSB and LSB
    signal Data_out_shell : std_logic_vector(15 downto 0) := x"0000";               --Shell signal for complete Data_out

begin
    
    start_edge <= '1' when (start_prev = '0' and Start = '1') else '0';             --Mimic rising clock edge
    
                                                                                    --STATE REGISTER LOGIC STARTS HERE
    state_register : process(clk)
    begin
        if (reset = '1') then
            current_state <= idle;
            MSB_shell <= (others => '0');
            LSB_shell <= (others => '0');                                           --Reset all states and values on an
            Data_out_shell <= (others => '0');                                      --async reset signal
            start_prev <= '0';
        elsif rising_edge(clk) then
            current_state <= next_state;
            start_prev <= Start;                                                    --Update current and previous start
            
            if (current_state = read_MSB and Done = '1' and Err ='0') then
                MSB_shell <= D_Out;                                                 --Load 8 MSB bits from TWI once read
            end if;                                                                 --is finished
            
            if (current_state = read_LSB and Done = '1' and Err = '0') then
                LSB_shell <= D_Out;                                                 --Load 8 LSB bits from TWI once read
            end if;                                                                 --is finished
            
            if (current_state = send_temp_out) then
                Data_out_shell <= MSB_shell & LSB_shell;                            --Combine into 16 bit output
            end if;
        end if;
    end process state_register;
    
    Data_out <= Data_out_shell;                                                     --Update actual data out input
    
                                                                                    --NEXT STATE LOGIC STARTS HERE
    Next_State_Logic : process(current_state, start_edge, Err, Done) is
    begin
        next_state <= current_state;                                                --Default to stay in current state unless
                                                                                    --prompted otherwise
        case current_state is
            when idle =>
                if (start_edge = '1') then
                    next_state <= read_MSB;                                         --Start read process on start edge
                end if;

            when read_MSB =>
                if (Err = '1') then                                                 --Check for error
                    next_state <= idle;
                elsif (Done = '1' and Err = '0') then                               --Change states when first read is done
                    next_state <= wait_done_low;
                end if;

            when wait_done_low =>
                if (Done = '0') then 
                    next_state <= read_LSB;                                         --Wait until done signal goes back to 0
                end if;                                                             --before moving to next state
                
            when read_LSB =>
                if (Err = '1') then                                                 --Check for error
                    next_state <= idle;
                elsif (Done = '1' and Err = '0') then                               --Change states when second read is done
                    next_state <= send_temp_out;
                end if;

            when send_temp_out =>
                if (Done = '0') then
                    next_state <= idle;                                             --Wait until done signal goes back to 0
                end if;                                                             --before moving back to idle

        end case;                                                                   --End case and process
    end process Next_State_Logic;
    
                                                                                    --OUTPUT LOGIC STARTS HERE
    output_logic : process(current_state, reset)
    begin

        SRST <= reset;        
        STB <= '0';
        MSG <= '0';
        A_In <= b"10010111";                                                        --Constant output values
        D_In <= x"00";
        
        case current_state is
            when idle =>
                STB <= '0';
            when read_MSB =>
                STB <= '1';                                                         --The strobe pulse value is all that
            when wait_done_low =>                                                   --changes in the ouput logic because
                stb <= '1';                                                         --Data_out was already given it's
            when read_LSB =>                                                        --value above in the register logic
                stb <= '1';
            when send_temp_out =>
                stb <= '0';
        end case;
    end process Output_Logic;
    
end architecture behavioral;