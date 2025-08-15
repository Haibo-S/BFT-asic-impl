# BFT ASIC Implementation using OpenROAD Flow

This repository uses `OpenROAD-impl` to collect ASIC implementation results, including power, timing, and area metrics. While the main repository contains the generated data, this repository includes the essential flow directory, which can be integrated into a fresh OpenROAD-flow-scripts setup to reproduce the results.


There are a list of other relevant repos:
- Main Repo: https://git.uwaterloo.ca/h3sun/720-noc-project
- OpenROAD-impl Repo: https://git.uwaterloo.ca/h3sun/openroad-flow-impl
- BFT Repo: https://git.uwaterloo.ca/watcag/bft
- Credit BFT Repo: https://git.uwaterloo.ca/watcag/bft-credit-vcs

## Getting started 
**Until August 2025**

Please get into one of the following ECE servers:

- uwing.eng.uwaterloo.ca  
- razorcrest.eng.uwaterloo.ca  
- haulcraft.eng.uwaterloo.ca  
- tantive4.eng.uwaterloo.ca  

Now copy over the full OpenROAD-flow-scripts directory:

    cp -r /scratch/OpenROAD-flow-scripts ./

**Note:** This copy step can take several minutes as the directory is large (over 9GB).

## Environment setup

Before using the OpenROAD flow, you must set the required environment variables. Add the following alias to your shell configuration file (e.g., `.bashrc` or `.zshrc`):

    cd OpenROAD-flow-scripts/flow

and then:

    alias openroadenv='\
    export FLOW_HOME=~/openroad-flow-impl/OpenROAD-flow-scripts/flow && \
    export OPENROAD=~/openroad-flow-impl/OpenROAD-flow-scripts/tools/OpenROAD && \
    export PATH=~/openroad-flow-impl/OpenROAD-flow-scripts/tools/OpenROAD/bin:$PATH && \
    export PATH=~/openroad-flow-impl/OpenROAD-flow-scripts/tools/yosys/bin:$PATH'

After updating your shell configuration, reload it and run:

    openroadenv

## Basic Flow Check

To verify that your OpenROAD flow is working properly, execute:

    make DESIGN_CONFIG=./designs/asap7/ibex/config.mk

To clean the flow results, run:

    make clean_all DESIGN_CONFIG=./designs/asap7/ibex/config.mk

Successful output will include lines like:

    cp results/asap7/ibex/base/6_1_merged.gds results/asap7/ibex/base/6_final.gds
    ./logs/asap7/ibex/base
    Log                            Elapsed seconds Peak Memory/MB
    1_1_yosys                                   26            185
    1_1_yosys_canonicalize                       0             93
    2_1_floorplan                                7            277
    2_2_floorplan_macro                          0            209
    2_3_floorplan_tapcell                        0            198
    2_4_floorplan_pdn                            0            213
    3_1_place_gp_skip_io                         4            244
    3_2_place_iop                                0            212
    3_3_place_gp                                24            444
    3_4_place_resized                           12            288
    3_5_place_dp                                10            358
    4_1_cts                                     16            407
    5_1_grt                                     27            706
    5_2_route                                  109           6807
    5_3_fillcell                                 1            312
    6_1_fill                                     0            238
    6_1_merge                                    1            529
    6_report                                    46            862
    Total                                      283           6807

This indicates that the flow has completed successfully. It is okay if your numbers differ slightly. The key indicator of success is the generation of the GDS file at:

    results/asap7/ibex/base/6_final.gds

You can verify its existence by running:

    ls results/asap7/ibex/base/6_final.gds


## Example Walkthrough

You can remove `flow` directory directly from the current `OpenROAD-flow-scripts` repo, and then replace it with the one we have here in this repo. 

After you have done that, you can run commands like:

    make clean_all DESIGN_CONFIG=./designs/asap7/deflection_bft/config.mk

and then 

    make DESIGN_CONFIG=./designs/asap7/deflection_bft/config.mk

to verify correctness. 

---

For more information on OpenROAD flow and its output reports, refer to the official documentation:

https://openroad-flow-scripts.readthedocs.io/en/latest/tutorials/FlowTutorial.html




