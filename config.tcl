# Main config
set ::env(DESIGN_NAME) usb_sky130

# SRAM is 386.480 BY 456.235
set ::env(FP_SIZING) "absolute"
set ::env(DIE_AREA) [list 0.0 0.0 1240.0 610.0]
set ::env(MACRO_PLACEMENT_CFG) $::env(DESIGN_DIR)/macro_placement.cfg
set ::env(FP_PIN_ORDER_CFG) $::env(DESIGN_DIR)/pin_order.cfg

# Can't run DRC on final GDS because SRAM
set ::env(MAGIC_DRC_USE_GDS) 0

# Sources
 # Local sources + no2usb sources
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v $::env(DESIGN_DIR)/no2usb/rtl/*.v]

 # Macros
set ::env(VERILOG_FILES_BLACKBOX) [glob $::env(DESIGN_DIR)/macros/bb/*.v]
set ::env(EXTRA_LEFS) [glob $::env(DESIGN_DIR)/macros/lef/*.lef]
set ::env(EXTRA_GDS_FILES) [glob $::env(DESIGN_DIR)/macros/gds/*.gds]

# Timing configuration
set ::env(CLOCK_PERIOD) "10"
set ::env(CLOCK_PORT) "clk"

# Cell library specific config
set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}

