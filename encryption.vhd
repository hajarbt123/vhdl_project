library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity encryption is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        intext : in STD_LOGIC_VECTOR(31 downto 0);
        outtext : out STD_LOGIC_VECTOR(31 downto 0);
	  mode : in STD_LOGIC -- encryption or decryption
	 );
end encryption;

architecture Behavioral of encryption is
    signal encrypted_text : std_logic_vector(31 downto 0);
    signal decrypted_text : std_logic_vector(31 downto 0);
    signal key : integer := 3;
begin
    process (clk, rst)
        variable i : integer;
        variable temp_text : std_logic_vector(7 downto 0);
        variable temp_result : integer;
    begin
        if rst = '1' then
            encrypted_text <= (others => '0');
            decrypted_text <= (others => '0');
            outtext <= (others => '0');
        elsif rising_edge(clk) then
            if mode = '0' then
                  -- Encryption 
                for i in 0 to 3 loop
                    temp_text := intext((i+1)*8-1 downto i*8);
                    temp_result := (to_integer(unsigned(temp_text)) - 97 + key) mod 26 + 97; -- ajuster pour ASCII 'a' to 'z'
                    encrypted_text((i+1)*8-1 downto i*8) <= std_logic_vector(to_unsigned(temp_result, 8));
                end loop;
                outtext <= encrypted_text;
            else
                -- Decryption
                for i in 0 to 3 loop
                    temp_text := intext((i+1)*8-1 downto i*8);
                    temp_result := (to_integer(unsigned(temp_text)) - 97 - key + 26) mod 26 + 97; -- Adjuste pour ASCII 'a' to 'z'
                    decrypted_text((i+1)*8-1 downto i*8) <= std_logic_vector(to_unsigned(temp_result, 8));
                end loop;
                outtext <= decrypted_text;
            end if;
        end if;
    end process;
end Behavioral;