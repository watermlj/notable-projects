----------------------------------------------------------------------------------
-- Company: Clarkson University
-- Engineer: Liam Waterman
-- 
-- Create Date: 11/02/2026 03:05:09 PM
-- Design Name: T-Flip-Flop
-- Module Name: tFlipFlop - Behavioral
-- Project Name: EE365 Project 5
-- Target Devices: Cora-Z707S
-- Tool Versions: Vivado 2019.1
-- Description: T-Flip-Flop implemented in FSM syntax because FSMs are ludicrously easy to design.
-- 
-- Dependencies: IEEE.STD_LOGIC_1164.ALL
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tFlipFlop is
    port ( clk : in STD_LOGIC;
           rawIn : in STD_LOGIC;
           tOut : out STD_LOGIC);
end tFlipFlop;

architecture Behavioral of tFlipFlop is

type state is (lowRelease, lowPress, highRelease, highPress);
signal currentState: state := lowRelease;

begin

    stateChange: process(clk)
    begin
        if rising_edge(clk) then
            case currentState is
                when lowRelease =>
                    if rawIn = '1' then
                        currentState <= lowPress;
                    else
                        currentState <= lowRelease;
                    end if;
                when lowPress =>
                    if rawIn = '0' then
                        currentState <= highRelease;
                    else
                        currentState <= lowPress;
                    end if;
                when highRelease =>
                    if rawIn = '1' then
                        currentState <= highPress;
                    else
                        currentState <= highRelease;
                    end if;
                when highPress =>
                    if rawIn = '0' then
                        currentState <= lowRelease;
                    else
                        currentState <= highPress;
                    end if;
                when others =>
                    currentState <= lowRelease;
                end case;
            end if;
    end process;

    output: process(clk)
    begin
        if rising_edge(clk) then
            case currentState is
                when lowRelease =>
                    tOut <= '0';
                when lowPress =>
                    tOut <= '0';
                when highRelease =>
                    tOut <= '1';
                when highPress =>
                    tOut <= '1';
                when others =>
                    tOut <= '0';
            end case;
        end if;
    end process;

end Behavioral;
