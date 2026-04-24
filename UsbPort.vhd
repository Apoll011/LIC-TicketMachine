-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions
-- and other software and tools, and any partner logic
-- functions, and any output files from any of the foregoing
-- (including device programming or simulation files), and any
-- associated documentation or information are expressly subject
-- to the terms and conditions of the Intel Program License
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"
-- CREATED		"Tue Mar 01 09:42:31 2022"

library ieee;
use ieee.std_logic_1164.all;

library work;

entity UsbPort is
    port (
        inputPort  : in  STD_LOGIC_VECTOR(7 downto 0);
        outputPort : out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity UsbPort;

architecture bdf_type of UsbPort is

    component sld_virtual_jtag is
        generic (
            lpm_type                :     STRING;
            sld_auto_instance_index :     STRING;
            sld_instance_index      :     INTEGER;
            sld_ir_width            :     INTEGER;
            sld_sim_action          :     STRING;
            sld_sim_n_scan          :     INTEGER;
            sld_sim_total_length    :     INTEGER
        );
        port (
            tdo                     : in  STD_LOGIC;
            ir_out                  : in  STD_LOGIC_VECTOR(7 downto 0);
            tck                     : out STD_LOGIC;
            tdi                     : out STD_LOGIC;
            virtual_state_cdr       : out STD_LOGIC;
            virtual_state_sdr       : out STD_LOGIC;
            virtual_state_e1dr      : out STD_LOGIC;
            virtual_state_pdr       : out STD_LOGIC;
            virtual_state_e2dr      : out STD_LOGIC;
            virtual_state_udr       : out STD_LOGIC;
            virtual_state_cir       : out STD_LOGIC;
            virtual_state_uir       : out STD_LOGIC;
            tms                     : out STD_LOGIC;
            jtag_state_tlr          : out STD_LOGIC;
            jtag_state_rti          : out STD_LOGIC;
            jtag_state_sdrs         : out STD_LOGIC;
            jtag_state_cdr          : out STD_LOGIC;
            jtag_state_sdr          : out STD_LOGIC;
            jtag_state_e1dr         : out STD_LOGIC;
            jtag_state_pdr          : out STD_LOGIC;
            jtag_state_e2dr         : out STD_LOGIC;
            jtag_state_udr          : out STD_LOGIC;
            jtag_state_sirs         : out STD_LOGIC;
            jtag_state_cir          : out STD_LOGIC;
            jtag_state_sir          : out STD_LOGIC;
            jtag_state_e1ir         : out STD_LOGIC;
            jtag_state_pir          : out STD_LOGIC;
            jtag_state_e2ir         : out STD_LOGIC;
            jtag_state_uir          : out STD_LOGIC;
            ir_in                   : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component sld_virtual_jtag;


begin

    b2v_inst: component sld_virtual_jtag
    generic map (
        lpm_type                => "sld_virtual_jtag",
        sld_auto_instance_index => "YES",
        sld_instance_index      => 0,
        sld_ir_width            => 8,
        sld_sim_action          => "UNUSED",
        sld_sim_n_scan          => 0,
        sld_sim_total_length    => 0
    )
    port map (
        ir_out                  => inputPort,
        ir_in                   => outputPort
    );

end architecture bdf_type;
