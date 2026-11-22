----------------------------------------------------------------------------------
-- Company: Clarkson University
-- Engineer: Liam Waterman
-- 
-- Create Date: 11/01/2026 11:27:47 PM
-- Design Name: Debouncer
-- Module Name: debouncer - Behavioral
-- Project Name: EE365 Project 5
-- Target Devices: Cora-Z707S
-- Tool Versions: Vivado 2019.1
-- Description: Debouncer for debouncing button inputs to the Cora-Z707S.
--              Uses an internal counter to ensure consistent input for
--              2^16 clock cycles before passing the signal through.
-- 
-- Dependencies: IEEE.STD_LOGIC_1164.ALL, IEEE.NUMERIC_STD.ALL
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer is
    port ( clk : in STD_LOGIC;
           rawIn : in STD_LOGIC;
           dbOut : out STD_LOGIC);
end debouncer;

architecture Behavioral of debouncer is

constant counterTarget: std_logic_vector(15 downto 0) := X"FFFF";
signal count: std_logic_vector(15 downto 0) := (others => '0');
signal startCount: std_logic := '0';
signal dbOutPrep: std_logic := '0';

begin

    debouncing: process(clk)
    begin
        if rising_edge(clk) then
            if count = counterTarget then
                dbOutPrep <= not dbOutPrep;
            end if;
        end if;
    end process;
    
    counting: process(clk)
    begin
        if rising_edge(clk) then
            if (rawIn = '1') xor (dbOutPrep = '1') then
                if count = counterTarget then
                    count <= (others => '0');
                else
                    count <= std_logic_vector(to_unsigned(to_integer(unsigned(count)) + 1, 16));
                end if;
            else
                count <= (others => '0');
            end if;
        end if;
    end process;
    
    dbOut <= dbOutPrep;
    
end Behavioral;
