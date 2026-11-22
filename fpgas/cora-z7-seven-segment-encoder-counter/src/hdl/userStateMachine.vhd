----------------------------------------------------------------------------------
-- Company: Clarkson University
-- Engineer: Liam Waterman
-- 
-- Create Date: 11/02/2026 03:33:21 PM
-- Design Name: User State Machine
-- Module Name: userStateMachine - Behavioral
-- Project Name: EE365 Project 5
-- Target Devices: Cora-Z707S
-- Tool Versions: Vivado 2019.1
-- Description: State machine designed to control data flow from some data source
--              to a TTLC or SPIC. Used here to hold data to a TTLC and SPIC
--              to communicate via UART/SPI to a four-digit seven-segment display, 
--              as well as send appropriate clear and move cursor commands.
-- 
-- Dependencies: 
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

entity userStateMachine is
    Port ( clk : in STD_LOGIC;
           iData : in STD_LOGIC_VECTOR (15 downto 0);
           busy : in STD_LOGIC;
           oData : buffer STD_LOGIC_VECTOR (7 downto 0);
           en : out STD_LOGIC);
end userStateMachine;

architecture Behavioral of userStateMachine is

type state is (idle0, send0, hold0, idle1, send1, hold1, idle2, send2, hold2, idle3, send3, hold3);
signal currentState: state := idle0;
signal bitCount: integer := 16;

begin

stateChange: process(clk)
begin
    if rising_edge(clk) then
        case currentState is
            when idle0 =>
                currentState <= send0;
            when send0 =>
                if busy = '1' then
                    currentState <= hold0;
                else
                    currentState <= send0;
                end if;
            when hold0 =>
                if busy = '0' then
                    currentState <= idle1;
                else
                    currentState <= hold0;
                end if;
            when idle1 =>
                currentState <= send1;
            when send1 =>
                if busy = '1' then
                    currentState <= hold1;
                else
                    currentState <= send1;
                end if;
            when hold1 =>
                if busy = '0' then
                    currentState <= idle2;
                else
                    currentState <= hold1;
                end if;
            when idle2 =>
                currentState <= send2;
            when send2 =>
                if busy = '1' then
                    currentState <= hold2;
                else
                    currentState <= send2;
                end if;
            when hold2 =>
                if busy = '1' then
                    currentState <= hold2;
                else
                    currentState <= idle3;
                end if;
            when idle3 =>
                currentState <= send3;
            when send3 =>
                if busy = '1' then
                    currentState <= hold3;
                else
                    currentState <= send3;
                end if;
            when hold3 =>
                if busy = '0' then
                    currentState <= idle1;
                else
                    currentState <= hold3;
                end if;
            when others =>
                currentState <= idle0;
        end case;
    end if;
end process;

output: process(clk)
begin
    if rising_edge(clk) then
        case currentState is
            when idle0 =>
                oData <= X"76";
                en <= '0';
                bitCount <= 16;
            when send0 =>
                oData <= oData;
                en <= '1';
            when hold0 =>
                oData <= oData;
                en <= '1';
            when idle1 =>
                oData <= "0000" & iData(bitCount - 1 downto bitCount - 4);
                en <= '0';
            when send1 =>
                oData <= oData;
                en <= '1';
            when hold1 =>
                oData <= oData;
                en <= '1';
            when idle2 =>
                oData <= X"79";
                en <= '0';
                bitCount <= bitCount - 4;
            when send2 =>
                oData <= oData;
                en <= '1';
            when hold2 =>
                oData <= oData;
                en <= '1';
            when idle3 =>
                case bitCount is
                    when 0 =>
                        oData <= X"00";
                    when 4 =>
                        oData <= X"03";
                    when 8 =>
                        oData <= X"02";
                    when 12 =>
                        oData <= X"01";
                    when others =>
                        oData <= X"00";
                end case;
                en <= '0';
            when send3 =>
                if bitCount = 0 then
                    bitCount <= 16;
                end if;
                oData <= oData;
                en <= '1';
            when hold3 =>
                oData <= oData;
                en <= '1';
            when others =>
                oData <= X"76";
                en <= '0';
        end case;
    end if;
end process;

end Behavioral;
