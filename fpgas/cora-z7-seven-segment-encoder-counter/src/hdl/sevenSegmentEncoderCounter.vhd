----------------------------------------------------------------------------------
-- Company: Clarkson University
-- Engineer: Liam Waterman
-- 
-- Create Date: 11/12/2026 06:04:48 PM
-- Design Name: Seven-Segment Encoder Counter
-- Module Name: sevenSegmentEncoderCounter - Behavioral
-- Project Name: Seven-Segment Encoder Counter Open House Project
-- Target Devices: Cora-Z707S
-- Tool Versions: Vivado 2019.1
-- Description: An encoder can be used to scroll up and down from numbers 0-255,
--              which are then display on a Sparkfun 4-digit 7-segment display.
-- 
-- Dependencies: IEEE.STD_LOGIC_1164.ALL
--               WORK.ALL:
--               -> SPIC.vhd
--               -> TTLC.vhd
--               -> FSM.vhd
--               -> debouncher.vhd
--               -> tFlipFlop.vhd
--               -> universalCounter.vhd
--               -> userStateMachine.vhd
-- 
-- Revision: 1.00
-- Revision 0.01 - File Created
-- Revision 1.00 - Top-level entity created and verified to be functional upon hardware implementation.
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

entity sevenSegmentEncoderCounter is
    Port ( rawA : in STD_LOGIC;
           rawB : in STD_LOGIC;
           clr_n : in STD_LOGIC;
           userEn : in STD_LOGIC;
           clk : in STD_LOGIC;
           init : out STD_LOGIC;
           isEn: out STD_LOGIC;
           Tx : out STD_LOGIC;
           SS : out STD_LOGIC;
           SCLK : out STD_LOGIC;
           MOSI : out STD_LOGIC);
end sevenSegmentEncoderCounter;

architecture Behavioral of sevenSegmentEncoderCounter is

    signal dbA: std_logic;
    signal dbB: std_logic;
    signal dbClr_n: std_logic;
    signal dbClr: std_logic;
    signal up: std_logic;
    signal dbUserEn: std_logic;
    signal dbtUserEn: std_logic;
    signal incrEn: std_logic;
    signal cntEn: std_logic;
    signal dataBin: std_logic_vector(13 downto 0);
    signal dataBCD: std_logic_vector(15 downto 0);
    signal byteOutTTL: std_logic_vector(7 downto 0);
    signal byteOutSPI: std_logic_vector(7 downto 0);
    signal enTTL: std_logic;
    signal enSPI: std_logic;
    signal busyTTL: std_logic;
    signal busySPI: std_logic;

begin

    dbClr <= not dbClr_n;
    cntEn <= incrEn and dbtUserEn;
    init <= dbClr;
    isEn <= dbtUserEn;
    
    ADebouncer: entity work.debouncer
        port map
        (
            clk => clk,
            rawIn => rawA,
            dbOut => dbA
        );
        
    BDebouncer: entity work.debouncer
        port map
        (
            clk => clk,
            rawIn => rawB,
            dbOut => dbB
        );
        
    clr_nDebouncer: entity work.debouncer
        port map
        (
            clk => clk,
            rawIn => clr_n,
            dbOut => dbClr_n
        );
        
    enDebouncer: entity work.debouncer
        port map
        (
            clk => clk,
            rawIn => userEn,
            dbOut => dbUserEn
        );
       
    enTFF: entity work.tFlipFlop
        port map
        (
            clk => clk,
            rawIn => dbUserEn,
            tOut => dbtUserEn
        );
        
    countingFSM: entity work.countingFSM
        port map
        (
            clk => clk,
            dbA => dbA,
            dbB => dbB,
            cntEn => incrEn,
            up => up
        );

    universalCounter: entity work.universalCounter
        generic map
        (
            N => 14,
            N2 => 9999,
            N1 => 0
        )
        port map
        (
            clk => clk,
            reset => dbClr,
            syn_clr => '0',
            load => '0',
            en => cntEn,
            up => up,
            clk_en => '1',
            d => (others => '0'),
            max_tick => open,
            min_tick => open,
            q => dataBin
        );
        
    binToBCD: entity work.binToBCD
        port map
        (
            bin_in => dataBin,
            bcd_out => dataBCD
        );
        
    TTLUSM: entity work.userStateMachine
        port map
        (
            clk => clk,
            iData => dataBCD,
            busy => busyTTL,
            oData => byteOutTTL,
            en => enTTL
        );
    
    SPIUSM: entity work.userStateMachine
        port map
        (
            clk => clk,
            iData => dataBCD,
            busy => busySPI,
            oData => byteOutSPI,
            en => enSPI
        );
        
    TTLC: entity work.TTLC
        port map
        (
            clk => clk,
            reset_n => dbClr_n,
            ena => enTTL,
            iData => byteOutTTL,
            busy => busyTTL,
            Tx => Tx
        );

    SPIC: entity work.SPIC
        port map
        (
            clk => clk,
            iReset_n => dbClr_n,
            iEna => enSPI,
            iData => byteOutSPI,
            oBusy => busySPI,
            SS => SS,
            SCLK => SCLK,
            MOSI => MOSI
        );

end Behavioral;
