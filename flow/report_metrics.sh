#!/bin/bash

DESIGN_CONFIG=./designs/asap7/deflection-bft/config.mk
LOG=0 # set this to 1 if you want to log terminal output

if [ "$LOG" -eq 1 ]; then
  EXPORT_LOG= ./report_metrics.log # path of your log file here
  exec > >(tee "$EXPORT_LOG") 2>&1
fi

make open_final DESIGN_CONFIG=$DESIGN_CONFIG <<'EOF'
report_design_area

report_worst_slack

report_tns

report_wns

report_power

exit

