----------------------------------------------------------------------------------
-- Company: Clarkson University
-- Engineer: Abul Khondker
-- 
-- Create Date: 11/02/2026 04:02:12 PM
-- Design Name: Serial-Peripheral Interface Controller (SPIC)
-- Module Name: SPIC - Behavioral
-- Project Name: EE365 Project 5
-- Target Devices: Cora-Z707S
-- Tool Versions: Vivado 2019.1
-- Description: Relays an input data bus at a specified 
--              subordinate-clock (SCLK) frequency via
--              SPI protocol. To change the desired SCLK
--              frequency, initialize countMax as
--              (f(sysClk) / (2 * f(SCLK))) - 1
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

entity SPIC is
    generic ( constant countMax : integer := 2499);
    port ( clk              : in std_logic;
           iData            : in std_logic_vector(7 downto 0);
           iReset_n         : in std_logic;
           iEna             : in std_logic;
           oBusy            : out std_logic;
           MOSI, SCLK, SS   : out std_logic );
end SPIC;

architecture state_machine of SPIC is

type state is (ready, prepare, write, done);
signal currentState: state := ready;
signal count : integer range 0 to countMax;
signal bitCount : integer := 7;
signal clkEn : std_logic;
signal data : std_logic_vector(7 downto 0);

begin

    clockEnable: process(clk, iReset_n)
    begin
        if iReset_n = '0' then
            count <= 0;
            clkEn <= '0';
        elsif rising_edge(clk) then
            if count = countMax then
                clkEn <= '1';
                count <= 0;
            else
                clkEn <= '0';
                count <= count + 1;
            end if;
        end if;
    end process;
    
    logicSPI: process(clk, clkEn, iReset_n)
    begin
        if iReset_n <= '0' then
            bitCount <= 7;
            MOSI <= '1';
            SS <= '1';
            SCLK <= '0';
            oBusy <= '1';
            currentState <= ready;
        elsif rising_edge(clk) and clkEn = '1' then
            case currentState is
                when ready =>
                    if iEna = '0' then
                        oBusy <= '0';
                        currentState <= ready;
                    else
                        oBusy <= '1';
                        SCLK <= '0';
                        SS <= '0';
                        data <= iData;
                        MOSI <= iData(7);
                        currentState <= prepare;
                    end if;
                when prepare =>
                    SCLK <= '1';
                    currentState <= write;
                when write =>
                    if bitCount /= 0 then
                        SCLK <= '0';
                        MOSI <= data(bitCount - 1);
                        bitCount <= bitCount - 1;
                        currentState <= prepare;
                    else
                        SCLK <= '0';
                        bitCount <= 7;
                        currentState <= done;
                    end if;
               when done =>
                    MOSI <= '1';
                    oBusy <= '0';
                    SS <= '1';
                    currentState <= ready;
               when others =>
                    currentState <= ready;
               end case;
           end if;
    end process;

end state_machine;
