library ieee;
use ieee.std_logic_1164.all;

entity countingFSM is
    port
    (

        dbA: in std_logic;
        dbB: in std_logic;
        clk: in std_logic;
        cntEn: out std_logic;
        up: out std_logic

    );

end countingFSM;

architecture Behavior of countingFSM is

   type state is (INIT, IN1, IN2, IN3, IN4, OUT1, OUT2, OUT3, OUT4);
   signal currentState: state;

	begin

        seq: process(clk)
        begin
            if rising_edge(clk) then
                case currentState is
                    when INIT =>
                        if dbA = '0' and dbB = '1' then
                            currentState <= IN1;
                        elsif dbA = '1' and dbB = '0' then
                            currentState <= OUT1;
                        else
                            currentState <= INIT;
                        end if;
                    when IN1 =>
                        if dbA = '1' and dbB = '1' then
                            currentState <= INIT;
                        elsif dbA = '0' and dbB = '0' then
                            currentState <= IN2;
                        else
                            currentState <= IN1;
                        end if;
                    when IN2 =>
                        if dbA = '0' and dbB = '1' then
                            currentState <= IN1;
                        elsif dbA = '1' and dbB = '0' then
                            currentState <= IN3;
                        else
                            currentState <= IN2;
                        end if;
                    when IN3 =>
                        if dbA = '0' and dbB = '0' then
                            currentState <= IN2;
                        elsif dbA = '1' and dbB = '1' then
                            currentState <= IN4;
                        else
                            currentState <= IN3;
                        end if;
                    when IN4 =>
                        currentState <= INIT;
                    when OUT1 =>
                        if dbA = '0' and dbB = '0' then
                            currentState <= OUT2;
                        elsif dbA = '1' and dbB = '1' then
                            currentState <= INIT;
                        else
                            currentState <= OUT1;
                        end if;
                    when OUT2 =>
                        if dbA = '0' and dbB = '1' then
                            currentState <= OUT3;
                        elsif dbA = '1' and dbB = '0' then
                            currentState <= OUT1;
                        else
                            currentState <= OUT2;
                        end if;
                    when OUT3 =>
                        if dbA = '1' and dbB = '1' then
                            currentState <= OUT4;
                        elsif dbA = '0' and dbB = '0' then
                            currentState <= OUT2;
                        end if;
                    when OUT4 =>
                        currentState <= INIT;
                    when others =>
                        currentState <= INIT;
                end case;
            end if;
        end process;

        comb: process(currentState)
        begin
            case currentState is
                when IN4 =>
                    cntEn <= '1';
                    up <= '1';
                when OUT4 =>
                    cntEn <= '1';
                    up <= '0';
                when others =>
                    cntEn <= '0';
                    up <= '0';
            end case;
				
	end process;
	
end Behavior;