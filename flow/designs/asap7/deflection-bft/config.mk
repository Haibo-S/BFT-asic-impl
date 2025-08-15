export PLATFORM               = asap7

export DESIGN_NICKNAME        = deflection-bft
export DESIGN_NAME            = bft

export VERILOG_FILES          = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/bft.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/client.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/mux.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/pi_route_lean.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/pi_route.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/pi_switch.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/t_route_lean.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/t_route.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/t_switch.v 

export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION       =  40
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY_LB_ADDON  = 0.20
