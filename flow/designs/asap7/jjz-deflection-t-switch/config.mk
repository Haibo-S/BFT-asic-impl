export PLATFORM               = asap7

export DESIGN_NICKNAME        = jjz-deflection-t-switch
export DESIGN_NAME            = t_switch

export VERILOG_FILES          = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/t_switch.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/t_route.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/t_route_lean.v \
                                $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/mux.v 

export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION       =  40
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY_LB_ADDON  = 0.20
