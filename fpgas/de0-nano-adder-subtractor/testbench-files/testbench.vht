library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity testbench is
end testbench;

architecture behavior of testbench is
    component addersubtractor
        generic
        (
            n : integer := 16
        ); 
        port
        (
            A, B : in std_logic_vector(n - 1 downto 0);
            Clock, Reset, Sel, AddSub : in std_logic;
            Z : buffer std_logic_vector(n - 1 downto 0);
            Overflow : out std_logic
        );
    end component;

    signal addend1 : std_logic_vector(15 downto 0);
    signal addend2 : std_logic_vector(15 downto 0);
    signal clock : std_logic;
    signal reset : std_logic;
    signal selector : std_logic;
    signal addsub : std_logic;
    signal overflow : std_logic;
    signal sum : std_logic_vector(15 downto 0);

begin

addSubInstance1 : addersubtractor port map (addend1, addend2, clock, reset, selector, addsub, sum, overflow);

    clockCycle: process
    begin

        -- Implements clock signal with T = 20 ns
        clock <= '0';
        wait for 10 ns;
        clock <= '1';
        wait for 10 ns;

    end process;

    arithmetic: process
    begin

        -- Clear addends, all other input logic is set to zero
        ---- selector 0 means no accumulation
        ---- addsub 0 means addition is performed
        addend1 <= (others => '0'); addend2 <= (others => '0');
        reset <= '1'; selector <= '0'; addsub <= '0';

        wait for 40 ns;

        reset <= '0';

        wait for 40 ns;

        -- Should perform 69 + 67 = 136 (0000000010001000)
        addend1 <= (0 => '1', 2 => '1', 6 => '1', others => '0');
        addend2 <= (0 => '1', 1 => '1', 6 => '1', others => '0');

        wait for 40 ns;

        -- Should perform 69 - 67 = 2 (0000000000000010)
        addsub <= '1';

        wait for 40 ns;

        -- Should cause addend2 (3) to be repeated added to the current sum (2) over 5 clock cycles
        addsub <= '0';
        selector <= '1';
        addend1 <= (others => '0');
        addend2 <= (0 => '1', 1 => '1', others => '0');

        wait for 100 ns;

        -- Should reset all inputs
        reset <= '1';

        wait for 20 ns;

        -- Driving reset low, waiting until end of testbench run
        reset <= '0';

        wait;

    end process;

end;