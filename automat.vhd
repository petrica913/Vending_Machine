library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AutomatVanzare is
  Port ( clk : in STD_LOGIC;
         rst : in STD_LOGIC;
         in_1 : in STD_LOGIC;  -- Semnal bancnota de 1 leu
         in_5 : in STD_LOGIC;  -- Semnal bancnota de 5 lei
         in_10 : in STD_LOGIC; -- Semnal bancnota de 10 lei
         req_prod : in STD_LOGIC; -- Cerere produs
         req_prod2: in STD_LOGIC; -- Cerere un al doilea produs
         req_change : in STD_LOGIC; -- Cerere rest
         out_prod : out STD_LOGIC; -- Eliberare produs
         out_prod2 : out STD_LOGIC; -- Eliberare al doilea produs
         out_change : out STD_LOGIC; -- Eliberare rest
         max_amount_reached : out STD_LOGIC); -- Semnal pentru suma maxim? acumulat? atins?
end AutomatVanzare;

architecture Behavioral of AutomatVanzare is
  type State is (Idle, Accumulate, Dispense, Dispense2, Change);
  shared variable accumulated_amount : integer := 0;
  signal current_state, next_state : State := Idle;
  shared variable cash_inside : integer := 0;
  shared variable dispended2 : boolean := false;
  shared variable dispended1 : boolean := false; 
 

begin

  process(clk, rst)
  begin
    if rst = '1' then
      accumulated_amount := 0;
      dispended1 := false;
      dispended2 := false;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process;

  process(current_state, in_1, in_5, in_10, req_prod, req_change)
  begin
    case current_state is
      when Idle =>
        if req_prod = '1' then
          next_state <= Accumulate;
        elsif req_change = '1' then
          next_state <= Change;
        else
          next_state <= Idle;
        end if;
        out_change <= '0';
        out_prod <= '0';
        out_prod2 <= '0';


      when Accumulate =>
        if req_prod = '1' and accumulated_amount >= 3 then
          next_state <= Dispense;
        elsif req_change = '1' and accumulated_amount > 10 then
          next_state <= Change;
        else
          next_state <= Accumulate;
        end if;

      when Dispense =>
        if req_prod = '1' and dispended1 = false then
          out_prod <= '1';
          accumulated_amount := accumulated_amount - 3;
          cash_inside := cash_inside + 3;
          dispended1 := true;
        else
          out_prod <= '0';
        end if;
        next_state <= Dispense2;
        
      when Dispense2 =>
        if req_prod2 = '1' and accumulated_amount >= 3 and dispended2 = false then
        out_prod2 <= '1';
        accumulated_amount := accumulated_amount - 3;
        cash_inside := cash_inside + 3;
        dispended2 := true;
        end if;
        next_state <= Change;

      when Change =>
        if req_change = '1' and accumulated_amount >= 10 and req_prod = '0' then
            accumulated_amount := accumulated_amount - 1;
        end if;
        if req_change = '1' then
          if accumulated_amount >= 5 then
            out_change <= '1';
            accumulated_amount := accumulated_amount - 5;
          end if;
          if accumulated_amount >= 5 then
            out_change <= '1';
            accumulated_amount := accumulated_amount - 5;
          end if;
    
          if accumulated_amount >= 1 then
            out_change <= '1';
            accumulated_amount := accumulated_amount - 1;
          end if;
          if accumulated_amount >= 1 then
            out_change <= '1';
            accumulated_amount := accumulated_amount - 1;
          end if;
          if accumulated_amount >= 1 then
            out_change <= '1';
            accumulated_amount := accumulated_amount - 1;
          end if;
          if accumulated_amount >= 1 then
            out_change <= '1';
            accumulated_amount := accumulated_amount - 1;
          end if;
        end if;
        if accumulated_amount >= 1 then
            next_state <= Change;
        else
            next_state <= Idle;
        end if;

      when others =>
      next_state <= Idle;
    end case;
  end process;

  process(in_1, in_5, in_10, req_prod, req_change)
  begin
    if in_1 = '1' and accumulated_amount <= 15  then
      accumulated_amount := accumulated_amount + 1;
     end if;
    if in_5 = '1' and accumulated_amount <= 15 then
      accumulated_amount := accumulated_amount + 5;
    end if;
    if in_10 = '1' and accumulated_amount <= 15 then
      accumulated_amount := accumulated_amount + 10;
    end if;

    if accumulated_amount >= 15 then
      max_amount_reached <= '1';
    else
      max_amount_reached <= '0';
    end if;

  end process;
end Behavioral;