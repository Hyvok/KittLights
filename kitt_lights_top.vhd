library ieee;
library work;
use ieee.std_logic_1164.all;

entity kitt_lights_top is
    generic
    (
        LIGHTS_N                : positive  := 8;
        ADVANCE_VAL             : positive  := 5000000;
        PWM_BITS_N              : positive  := 8;
        DECAY_VAL               : positive  := 52000
    );
    port
    (
        clk_in                  : in std_logic;
        reset_in                : in std_logic;
        lights_out              : out std_logic_vector(LIGHTS_N - 1 downto 0)
    );
end entity;

architecture rtl of kitt_lights_top is

    signal reset                : std_logic;
    signal lights               : std_logic_vector(LIGHTS_N - 1 downto 0);

begin

    -- Synchronize reset signal to clock and invert it
    sync_reset_p: process(clk_in, reset)
    begin
        if rising_edge(clk_in) then
            if reset_in = '0' then
                reset <= '1';
            else
                reset <= '0';
            end if;
        end if;
    end process;

    -- Invert signal for LEDs
    lights_out <= not lights;

    kitt_lights_p: entity work.kitt_lights(rtl)
    generic map
    (
        LIGHTS_N                => LIGHTS_N,
        ADVANCE_VAL             => ADVANCE_VAL,
        PWM_BITS_N              => PWM_BITS_N,
        DECAY_VAL               => DECAY_VAL
    )
    port map
    (
        clk                     => clk_in,
        reset                   => reset,
        lights_out              => lights
    );

end;
