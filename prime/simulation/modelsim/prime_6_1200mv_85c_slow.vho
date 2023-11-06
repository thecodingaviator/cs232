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

-- DATE "09/19/2023 22:23:13"

-- 
-- Device: Altera EP3C16F484C6 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEIII;
LIBRARY IEEE;
USE CYCLONEIII.CYCLONEIII_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	prime IS
    PORT (
	O : OUT std_logic;
	A : IN std_logic;
	C : IN std_logic;
	D : IN std_logic;
	B : IN std_logic
	);
END prime;

-- Design Ports Information
-- O	=>  Location: PIN_F7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- D	=>  Location: PIN_B3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- C	=>  Location: PIN_E6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- B	=>  Location: PIN_E5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- A	=>  Location: PIN_G7,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF prime IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_O : std_logic;
SIGNAL ww_A : std_logic;
SIGNAL ww_C : std_logic;
SIGNAL ww_D : std_logic;
SIGNAL ww_B : std_logic;
SIGNAL \O~output_o\ : std_logic;
SIGNAL \C~input_o\ : std_logic;
SIGNAL \B~input_o\ : std_logic;
SIGNAL \A~input_o\ : std_logic;
SIGNAL \D~input_o\ : std_logic;
SIGNAL \inst4~0_combout\ : std_logic;

BEGIN

O <= ww_O;
ww_A <= A;
ww_C <= C;
ww_D <= D;
ww_B <= B;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

-- Location: IOOBUF_X1_Y29_N9
\O~output\ : cycloneiii_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => \inst4~0_combout\,
	devoe => ww_devoe,
	o => \O~output_o\);

-- Location: IOIBUF_X1_Y29_N22
\C~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_C,
	o => \C~input_o\);

-- Location: IOIBUF_X1_Y29_N29
\B~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_B,
	o => \B~input_o\);

-- Location: IOIBUF_X1_Y29_N15
\A~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_A,
	o => \A~input_o\);

-- Location: IOIBUF_X3_Y29_N8
\D~input\ : cycloneiii_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_D,
	o => \D~input_o\);

-- Location: LCCOMB_X2_Y28_N0
\inst4~0\ : cycloneiii_lcell_comb
-- Equation(s):
-- \inst4~0_combout\ = (\B~input_o\ & (\D~input_o\ & ((!\A~input_o\) # (!\C~input_o\)))) # (!\B~input_o\ & (\C~input_o\ & ((\D~input_o\) # (!\A~input_o\))))

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0110111000000010",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	dataa => \C~input_o\,
	datab => \B~input_o\,
	datac => \A~input_o\,
	datad => \D~input_o\,
	combout => \inst4~0_combout\);

ww_O <= \O~output_o\;
END structure;


