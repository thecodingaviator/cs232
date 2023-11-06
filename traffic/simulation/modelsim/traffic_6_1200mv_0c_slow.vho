-- Copyright (C) 1991-2012 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus II 32-bit"
-- VERSION "Version 12.1 Build 177 11/07/2012 SJ Full Version"

-- DATE "09/24/2023 20:39:55"

-- 
-- Device: Altera EP3C16F484C6 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY CYCLONEIII;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE CYCLONEIII.CYCLONEIII_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	traffic IS
    PORT (
	NS_R : OUT std_logic;
	clk : IN std_logic;
	reset : IN std_logic;
	enable : IN std_logic;
	NS_Y : OUT std_logic;
	NS_G : OUT std_logic;
	EW_R : OUT std_logic;
	EW_Y : OUT std_logic;
	EW_G : OUT std_logic
	);
END traffic;

-- Design Ports Information
-- NS_R	=>  Location: PIN_H7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NS_Y	=>  Location: PIN_E1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- NS_G	=>  Location: PIN_H6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- EW_R	=>  Location: PIN_D2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- EW_Y	=>  Location: PIN_J6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- EW_G	=>  Location: PIN_E3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- enable	=>  Location: PIN_F2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_G2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- reset	=>  Location: PIN_G1,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF traffic IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_NS_R : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_reset : std_logic;
SIGNAL ww_enable : std_logic;
SIGNAL ww_NS_Y : std_logic;
SIGNAL ww_NS_G : std_logic;
SIGNAL ww_EW_R : std_logic;
SIGNAL ww_EW_Y : std_logic;
SIGNAL ww_EW_G : std_logic;
SIGNAL \clk~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \reset~inputclkctrl_INCLK_bus\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \clk~inputclkctrl_outclk\ : std_logic;
SIGNAL \NS_R~output_o\ : std_logic;
SIGNAL \NS_Y~output_o\ : std_logic;
SIGNAL \NS_G~output_o\ : std_logic;
SIGNAL \EW_R~output_o\ : std_logic;
SIGNAL \EW_Y~output_o\ : std_logic;
SIGNAL \EW_G~output_o\ : std_logic;
SIGNAL \enable~input_o\ : std_logic;
SIGNAL \inst|cnt[0]~4_combout\ : std_logic;
SIGNAL \reset~input_o\ : std_logic;
SIGNAL \reset~inputclkctrl_outclk\ : std_logic;
SIGNAL \inst|cnt[1]~3_combout\ : std_logic;
SIGNAL \inst|cnt[2]~2_combout\ : std_logic;
SIGNAL \inst|cnt[3]~0_combout\ : std_logic;
SIGNAL \inst|cnt[3]~1_combout\ : std_logic;
SIGNAL \inst9~combout\ : std_logic;
SIGNAL \inst8~combout\ : std_logic;
SIGNAL \inst13~0_combout\ : std_logic;
SIGNAL \inst16~combout\ : std_logic;
SIGNAL \inst15~combout\ : std_logic;
SIGNAL \inst19~0_combout\ : std_logic;
SIGNAL \inst|cnt\ : std_logic_vector(3 DOWNTO 0);
SIGNAL \ALT_INV_reset~inputclkctrl_outclk\ : std_logic;

BEGIN

NS_R <= ww_NS_R;
ww_clk <= clk;
ww_reset <= reset;
ww_enable <= enable;
NS_Y <= ww_NS_Y;
NS_G <= ww_NS_G;
EW_R <= ww_EW_R;
EW_Y <= ww_EW_Y;
EW_G <= ww_EW_G;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\clk~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \clk~input_o\);

\reset~inputclkctrl_INCLK_bus\ <= (vcc & vcc & vcc & \reset~input_o\);
\ALT_INV_reset~inputclkctrl_outclk\ <= NOT \reset~inputclkctrl_outclk\;

-- Location: IOIBUF_X0_Y14_N1
\clk~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: CLKCTRL_G4
\clk~inputclkctrl\ : cycloneiii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \clk~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \clk~inputclkctrl_outclk\);

-- Location: IOOBUF_X0_Y25_N16
\NS_R~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst9~combout\,
	devoe => ww_devoe,
	o => \NS_R~output_o\);

-- Location: IOOBUF_X0_Y24_N16
\NS_Y~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst8~combout\,
	devoe => ww_devoe,
	o => \NS_Y~output_o\);

-- Location: IOOBUF_X0_Y25_N23
\NS_G~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst13~0_combout\,
	devoe => ww_devoe,
	o => \NS_G~output_o\);

-- Location: IOOBUF_X0_Y25_N2
\EW_R~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst16~combout\,
	devoe => ww_devoe,
	o => \EW_R~output_o\);

-- Location: IOOBUF_X0_Y24_N2
\EW_Y~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst15~combout\,
	devoe => ww_devoe,
	o => \EW_Y~output_o\);

-- Location: IOOBUF_X0_Y26_N9
\EW_G~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst19~0_combout\,
	devoe => ww_devoe,
	o => \EW_G~output_o\);

-- Location: IOIBUF_X0_Y24_N22
\enable~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_enable,
	o => \enable~input_o\);

-- Location: LCCOMB_X1_Y25_N18
\inst|cnt[0]~4\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|cnt[0]~4_combout\ = \inst|cnt\(0) $ (\enable~input_o\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|cnt\(0),
	datad => \enable~input_o\,
	combout => \inst|cnt[0]~4_combout\);

-- Location: IOIBUF_X0_Y14_N8
\reset~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_reset,
	o => \reset~input_o\);

-- Location: CLKCTRL_G2
\reset~inputclkctrl\ : cycloneiii_clkctrl
-- pragma translate_off
GENERIC MAP (
	clock_type => "global clock",
	ena_register_mode => "none")
-- pragma translate_on
PORT MAP (
	inclk => \reset~inputclkctrl_INCLK_bus\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	outclk => \reset~inputclkctrl_outclk\);

-- Location: FF_X1_Y25_N19
\inst|cnt[0]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \inst|cnt[0]~4_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|cnt\(0));

-- Location: LCCOMB_X1_Y25_N16
\inst|cnt[1]~3\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|cnt[1]~3_combout\ = \inst|cnt\(1) $ (((\enable~input_o\ & \inst|cnt\(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0101101011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \enable~input_o\,
	datac => \inst|cnt\(1),
	datad => \inst|cnt\(0),
	combout => \inst|cnt[1]~3_combout\);

-- Location: FF_X1_Y25_N17
\inst|cnt[1]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \inst|cnt[1]~3_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|cnt\(1));

-- Location: LCCOMB_X1_Y25_N26
\inst|cnt[2]~2\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|cnt[2]~2_combout\ = \inst|cnt\(2) $ (((\enable~input_o\ & (\inst|cnt\(1) & \inst|cnt\(0)))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0111100011110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \enable~input_o\,
	datab => \inst|cnt\(1),
	datac => \inst|cnt\(2),
	datad => \inst|cnt\(0),
	combout => \inst|cnt[2]~2_combout\);

-- Location: FF_X1_Y25_N27
\inst|cnt[2]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \inst|cnt[2]~2_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|cnt\(2));

-- Location: LCCOMB_X1_Y25_N0
\inst|cnt[3]~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|cnt[3]~0_combout\ = (\enable~input_o\ & (\inst|cnt\(1) & (\inst|cnt\(2) & \inst|cnt\(0))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \enable~input_o\,
	datab => \inst|cnt\(1),
	datac => \inst|cnt\(2),
	datad => \inst|cnt\(0),
	combout => \inst|cnt[3]~0_combout\);

-- Location: LCCOMB_X1_Y25_N24
\inst|cnt[3]~1\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst|cnt[3]~1_combout\ = \inst|cnt\(3) $ (\inst|cnt[3]~0_combout\)

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000111111110000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datac => \inst|cnt\(3),
	datad => \inst|cnt[3]~0_combout\,
	combout => \inst|cnt[3]~1_combout\);

-- Location: FF_X1_Y25_N25
\inst|cnt[3]\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clk~inputclkctrl_outclk\,
	d => \inst|cnt[3]~1_combout\,
	clrn => \ALT_INV_reset~inputclkctrl_outclk\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \inst|cnt\(3));

-- Location: LCCOMB_X1_Y25_N4
inst9 : cycloneiii_lcell_comb
-- Equation(s):
-- \inst9~combout\ = (\inst|cnt\(3)) # ((!\inst|cnt\(0) & (!\inst|cnt\(1) & !\inst|cnt\(2))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1111111100000001",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|cnt\(0),
	datab => \inst|cnt\(1),
	datac => \inst|cnt\(2),
	datad => \inst|cnt\(3),
	combout => \inst9~combout\);

-- Location: LCCOMB_X1_Y25_N30
inst8 : cycloneiii_lcell_comb
-- Equation(s):
-- \inst8~combout\ = (\inst|cnt\(1) & (\inst|cnt\(2) & !\inst|cnt\(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000011000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst|cnt\(1),
	datac => \inst|cnt\(2),
	datad => \inst|cnt\(3),
	combout => \inst8~combout\);

-- Location: LCCOMB_X1_Y25_N12
\inst13~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst13~0_combout\ = (!\inst|cnt\(3) & ((\inst|cnt\(1) & ((!\inst|cnt\(2)))) # (!\inst|cnt\(1) & ((\inst|cnt\(0)) # (\inst|cnt\(2))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000111110",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|cnt\(0),
	datab => \inst|cnt\(1),
	datac => \inst|cnt\(2),
	datad => \inst|cnt\(3),
	combout => \inst13~0_combout\);

-- Location: LCCOMB_X1_Y25_N22
inst16 : cycloneiii_lcell_comb
-- Equation(s):
-- \inst16~combout\ = ((!\inst|cnt\(0) & (!\inst|cnt\(1) & !\inst|cnt\(2)))) # (!\inst|cnt\(3))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000111111111",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|cnt\(0),
	datab => \inst|cnt\(1),
	datac => \inst|cnt\(2),
	datad => \inst|cnt\(3),
	combout => \inst16~combout\);

-- Location: LCCOMB_X1_Y25_N20
inst15 : cycloneiii_lcell_comb
-- Equation(s):
-- \inst15~combout\ = (\inst|cnt\(1) & (\inst|cnt\(2) & \inst|cnt\(3)))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "1100000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	datab => \inst|cnt\(1),
	datac => \inst|cnt\(2),
	datad => \inst|cnt\(3),
	combout => \inst15~combout\);

-- Location: LCCOMB_X1_Y25_N10
\inst19~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst19~0_combout\ = (\inst|cnt\(3) & ((\inst|cnt\(1) & ((!\inst|cnt\(2)))) # (!\inst|cnt\(1) & ((\inst|cnt\(0)) # (\inst|cnt\(2))))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0011111000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \inst|cnt\(0),
	datab => \inst|cnt\(1),
	datac => \inst|cnt\(2),
	datad => \inst|cnt\(3),
	combout => \inst19~0_combout\);

ww_NS_R <= \NS_R~output_o\;

ww_NS_Y <= \NS_Y~output_o\;

ww_NS_G <= \NS_G~output_o\;

ww_EW_R <= \EW_R~output_o\;

ww_EW_Y <= \EW_Y~output_o\;

ww_EW_G <= \EW_G~output_o\;
END structure;


