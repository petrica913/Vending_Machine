library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TestBench_AutomatVanzare is
end TestBench_AutomatVanzare;

architecture Behavioral of TestBench_AutomatVanzare is
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal in_1, in_5, in_10, req_prod, req_prod2, req_change : STD_LOGIC := '0';
    signal out_prod, out_prod2, out_change, max_amount_reached : STD_LOGIC;

    constant CLOCK_PERIOD : time := 10 ns; -- Define the clock period

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: entity work.AutomatVanzare
        port map (
            clk => clk,
            rst => rst,
            in_1 => in_1,
            in_5 => in_5,
            in_10 => in_10,
            req_prod => req_prod,
            req_prod2 => req_prod2,
            req_change => req_change,
            out_prod => out_prod,
            out_prod2 => out_prod2,
            out_change => out_change,
            max_amount_reached => max_amount_reached
        );

    -- Clock process
    process
    begin
        while now < 1000 ns loop
            clk <= not clk;
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    process
    begin
        -- Apply a reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        

        -- Test case 3: Apply various inputs
        in_1 <= '1';
        in_5 <= '0';
        in_10 <= '1';
        wait for 20 ns;
        in_1 <= '1';
        in_5 <= '0';
        in_10 <= '0';
        req_prod <= '1';
        wait for 50 ns;
        in_1 <= '0';
        in_5 <= '0';
        in_10 <= '0';
        req_prod <= '0';
        req_change <= '1';
        wait for 50 ns;
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        in_1 <= '1';
        in_5 <= '0';
        in_10 <= '1';
        req_change <= '1';
        wait for 20 ns;
        

        -- Additional test cases can be added as needed

        wait;
    end process;

end Behavioral;