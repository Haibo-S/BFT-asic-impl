export PLATFORM               = asap7

export DESIGN_NICKNAME        = credit-bft
export DESIGN_NAME            = topology_t_binary_tree_wrap

export VERILOG_FILES          = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/merged.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/mux.v
#                                 $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/common_pkg.sv \
#                                 $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/credit_bp_rx.sv \
#                                 $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/credit_counters_tx.sv \
#                                 $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/fifo32.sv \
#                                 $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/matrix_arbiter.sv \
#                                 $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/mux.sv \
#                                 $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/noc_if.sv \
#                                 $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/noc_pipe.sv \
#                                 $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/t_route.sv \
#                                 $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/t_switch_top.sv \
#                                 $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/t_switch.sv \
#                                 $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/topology_t_binary_tree.sv

export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION       =  40
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY_LB_ADDON  = 0.20
