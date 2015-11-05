library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils_pkg.all;

entity kitt_lights is
    generic
    (
        -- Number of LEDs
        LIGHTS_N                : positive;
        -- Number of clock cycles to advance an LED
        ADVANCE_VAL             : positive;
        -- Number of bits in the PWM counter
        PWM_BITS_N              : positive;
        -- Number of clock cycles for an LED to decay one PWM step
        DECAY_VAL               : positive
    );
    port
    (
        clk                     : in std_logic;
        reset                   : in std_logic;
        lights_out              : out std_logic_vector(LIGHTS_N - 1 downto 0)
    );
end entity;

architecture rtl of kitt_lights is

    type decay_t is array (lights_out'range)
        of unsigned(PWM_BITS_N - 1 downto 0);

    signal decay                : decay_t;
    signal active               : std_logic_vector(lights_out'range);

begin

    -- Advance currently active LED
    advance_p: process(clk, reset)
        variable timer          : unsigned(ceil_log2(ADVANCE_VAL) downto 0);
        variable dir_up         : boolean;
    begin
        if reset = '1' then
            active <= (others => '0');
            timer := (others => '0');
            dir_up := false;
        elsif rising_edge(clk) then

            -- If all lights are off
            if active = (active'range => '0') then
                active(0) <= '1';

            -- Delay done, advance to next LED
            elsif timer = ADVANCE_VAL then
                timer := (others => '0');

                -- Change direction
                if active(active'left) = '1' or active(active'right) = '1' then
                    dir_up := not dir_up;
                end if;

                -- Advance
                if dir_up = true then
                    active <= shift_left_vec(active, 1);
                else
                    active <= shift_right_vec(active, 1);
                end if;

            else
                timer := timer + 1;
            end if;
        end if;
    end process;

    -- Calculate PWM values for all LEDs and decay them when LED is not active
    decay_p: process(clk, reset)
        variable counter        : unsigned(ceil_log2(DECAY_VAL) downto 0);
    begin
        if reset = '1' then
            decay <= (others => (others => '0'));
            counter := (others => '0');
        elsif rising_edge(clk) then

            -- Delay done, decay PWM values
            if counter = DECAY_VAL then
                counter := (others => '0');

                -- Calculate new PWM values
                for i in 0 to decay'high loop

                    -- LED is currently active, apply full duty cycle
                    if active(i) = '1' then
                        decay(i) <= to_unsigned(2**PWM_BITS_N - 1, PWM_BITS_N);

                    -- LED is not active, decay PWM value
                    elsif active(i) = '0' then

                        -- Make sure decay does not wrap
                        if decay(i) >= 1 then
                            decay(i) <= decay(i) - to_unsigned(1, PWM_BITS_N);
                        else
                            decay(i) <= (others => '0');
                        end if;
                    end if;
                end loop;
            end if;
            counter := counter + 1;
        end if;
    end process;

    -- Apply PWM values
    pwm_p: process(clk, reset)
        variable pwm_timer      : unsigned(PWM_BITS_N - 1 downto 0);
    begin
        if reset = '1' then
            pwm_timer := (others => '0');
            lights_out <= (others => '0');
        elsif rising_edge(clk) then

            -- Apply to all LED outputs
            for i in 0 to lights_out'high loop
                if pwm_timer <= decay(i) and not (decay(i) = 0) then
                    lights_out(i) <= '1';
                else
                    lights_out(i) <= '0';
                end if;
            end loop;

            pwm_timer := pwm_timer + 1;
        end if;
    end process;

end;
