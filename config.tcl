# Global
# ------

# Name
set ::env(DESIGN_NAME) usb_sky130

# We're a macro
set ::env(DESIGN_IS_CORE) 0

# Diode insertion: Spray
set ::env(DIODE_INSERTION_STRATEGY) 1

# Timing configuration
set ::env(CLOCK_PERIOD) "10"
set ::env(CLOCK_PORT) "clk"


# Sources
# -------

# Local sources + no2usb sources
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v $::env(DESIGN_DIR)/no2usb/rtl/*.v]

# Macros
set ::env(VERILOG_FILES_BLACKBOX) [glob $::env(DESIGN_DIR)/macros/bb/*.v]
set ::env(EXTRA_LEFS) [glob $::env(DESIGN_DIR)/macros/lef/*.lef]
set ::env(EXTRA_GDS_FILES) [glob $::env(DESIGN_DIR)/macros/gds/*.gds]


# Floorplanning
# -------------

# Fixed area and pin position
set ::env(FP_SIZING) "absolute"
set ::env(DIE_AREA) [list 0.0 0.0 1288.0 575.0]
set ::env(FP_PIN_ORDER_CFG) $::env(DESIGN_DIR)/pin_order.cfg

# SRAM is 386.480 BY 456.235, place 3 at the top
set ::env(MACRO_PLACEMENT_CFG) $::env(DESIGN_DIR)/macro_placement.cfg

# Halo around the SRAMs
set ::env(FP_HORIZONTAL_HALO) 20
set ::env(FP_VERTICAL_HALO) 20

# Because we're sort of compressed vertically use smaller pitch
# Also try to make it neatly aligned
set ::env(FP_PDN_HOFFSET) 4.66
set ::env(FP_PDN_HPITCH) 40.8

set ::env(FP_PDN_VOFFSET) 10.58
set ::env(FP_PDN_VPITCH) 119.6


# Placement
# ---------

set ::env(PL_TARGET_DENSITY) 0.525


# Routing
# -------

# Go fast
set ::env(ROUTING_CORES) 6

# It's overly worried about congestion, but it's fine
set ::env(GLB_RT_ALLOW_CONGESTION) 1

# Avoid li1/met5 for routing
set ::env(GLB_RT_MINLAYER) 2
set ::env(GLB_RT_MAXLAYER) 5


# DRC
# ---

# Can't run DRC on final GDS because SRAM
set ::env(MAGIC_DRC_USE_GDS) 0


# Cell library specific config
# ----------------------------

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}
