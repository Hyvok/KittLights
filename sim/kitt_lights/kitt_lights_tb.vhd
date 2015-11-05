library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity kitt_lights_tb is
end entity;

architecture rtl of kitt_lights_tb is

    -- Main clock frequency 50 MHz
    constant CLK_PERIOD     : time := 1 sec / 50e6;

    signal clk              : std_logic := '0';
    signal reset            : std_logic;
begin

    reset <= '1', '0' after 500 ns;

    clk_gen: process(clk)
    begin
        clk <= not clk after CLK_PERIOD / 2;
    end process;

    DUT_inst: entity work.kitt_lights(rtl)
    generic map
    (
        LIGHTS_N            => 8,
        ADVANCE_VAL         => 100000,
        PWM_BITS_N          => 8,
        DECAY_VAL           => 2000
    )
    port map
    (
        clk                 => clk,
        reset               => reset
    );

end;
