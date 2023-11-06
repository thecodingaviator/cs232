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

-- PROGRAM		"Quartus II 32-bit"
-- VERSION		"Version 12.1 Build 177 11/07/2012 SJ Full Version"
-- CREATED		"Sun Sep 24 20:42:37 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY traffic IS 
	PORT
	(
		enable :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		NS_R :  OUT  STD_LOGIC;
		NS_Y :  OUT  STD_LOGIC;
		NS_G :  OUT  STD_LOGIC;
		EW_R :  OUT  STD_LOGIC;
		EW_Y :  OUT  STD_LOGIC;
		EW_G :  OUT  STD_LOGIC
	);
END traffic;

ARCHITECTURE bdf_type OF traffic IS 

COMPONENT counter
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	q :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	W :  STD_LOGIC;
SIGNAL	X :  STD_LOGIC;
SIGNAL	Y :  STD_LOGIC;
SIGNAL	Z :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;


BEGIN 



b2v_inst : counter
PORT MAP(clk => clk,
		 reset => reset,
		 enable => enable,
		 q => q);


SYNTHESIZED_WIRE_2 <= W AND X AND q(0);


SYNTHESIZED_WIRE_1 <= W AND q(2) AND Y;


NS_G <= SYNTHESIZED_WIRE_0 OR SYNTHESIZED_WIRE_1 OR SYNTHESIZED_WIRE_2;


SYNTHESIZED_WIRE_3 <= X AND Y AND Z;


EW_Y <= q(3) AND q(2) AND q(1);


EW_R <= SYNTHESIZED_WIRE_3 OR W;


SYNTHESIZED_WIRE_6 <= q(3) AND X AND q(0);


SYNTHESIZED_WIRE_4 <= q(3) AND X AND q(1);


EW_G <= SYNTHESIZED_WIRE_4 OR SYNTHESIZED_WIRE_5 OR SYNTHESIZED_WIRE_6;


SYNTHESIZED_WIRE_0 <= W AND X AND q(1);


SYNTHESIZED_WIRE_5 <= q(3) AND q(2) AND Y;


W <= NOT(q(3));



X <= NOT(q(2));



Y <= NOT(q(1));



Z <= NOT(q(0));



SYNTHESIZED_WIRE_7 <= X AND Y AND Z;


NS_Y <= W AND q(2) AND q(1);


NS_R <= SYNTHESIZED_WIRE_7 OR q(3);


END bdf_type;