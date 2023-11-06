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
-- CREATED		"Mon Sep 25 15:14:27 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY flash IS 
	PORT
	(
		a :  IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		result :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END flash;

ARCHITECTURE bdf_type OF flash IS 

COMPONENT boxdriver
	PORT(a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;



BEGIN 



b2v_inst : boxdriver
PORT MAP(a => a,
		 result => result);


END bdf_type;