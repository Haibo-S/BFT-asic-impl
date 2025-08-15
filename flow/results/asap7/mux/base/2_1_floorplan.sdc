###############################################################################
# Created by write_sdc
###############################################################################
current_design mux
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name core_clock -period 1000.0000 [get_ports {clk}]
set_input_delay 200.0000 -clock [get_clocks {core_clock}] -add_delay [get_ports {a}]
set_input_delay 200.0000 -clock [get_clocks {core_clock}] -add_delay [get_ports {b}]
set_input_delay 200.0000 -clock [get_clocks {core_clock}] -add_delay [get_ports {rst}]
set_input_delay 200.0000 -clock [get_clocks {core_clock}] -add_delay [get_ports {sel}]
set_output_delay 200.0000 -clock [get_clocks {core_clock}] -add_delay [get_ports {y}]
###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################
