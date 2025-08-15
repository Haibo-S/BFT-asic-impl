export PLATFORM               = asap7

export DESIGN_NICKNAME        = mux
export DESIGN_NAME            = mux

export VERILOG_FILES          = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/mux.v 

export SDC_FILE               = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

export CORE_UTILIZATION       =  40
export CORE_ASPECT_RATIO      = 1
export CORE_MARGIN            = 2
export PLACE_DENSITY_LB_ADDON  = 0.20
