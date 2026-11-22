----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/12/2026 07:39:24 PM
-- Design Name: 
-- Module Name: binToBCD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity binToBCD is
    Port (
        bin_in  : in  STD_LOGIC_VECTOR(13 downto 0); -- Numbers 0-9999 require 14 bits to hold
        bcd_out : out STD_LOGIC_VECTOR(15 downto 0)  -- Thousands, Hundreds, Tens, Ones
    );
end binToBCD;

architecture Behavioral of binToBCD is
begin
    process(bin_in)
        -- 16 bits for 4 BCD digits + 14 bits for binary input = 30 bits
        variable scratch : UNSIGNED(29 downto 0);
    begin
        scratch := (others => '0');
        scratch(13 downto 0) := UNSIGNED(bin_in);

        for i in 0 to 13 loop
            -- Check Ones (bits 17..14)
            if scratch(17 downto 14) >= 5 then
                scratch(17 downto 14) := scratch(17 downto 14) + 3;
            end if;
            -- Check Tens (bits 21..18)
            if scratch(21 downto 18) >= 5 then
                scratch(21 downto 18) := scratch(21 downto 18) + 3;
            end if;
            -- Check Hundreds (bits 25..22)
            if scratch(25 downto 22) >= 5 then
                scratch(25 downto 22) := scratch(25 downto 22) + 3;
            end if;
            -- Check Thousands (bit 29..26)
            if scratch(29 downto 26) >= 5 then
                scratch(29 downto 26) := scratch(29 downto 26) + 3;
            end if;

            -- Shift entire scratch register left by 1
            scratch := shift_left(scratch, 1);
        end loop;

        bcd_out <= STD_LOGIC_VECTOR(scratch(29 downto 14));
    end process;
end Behavioral;

