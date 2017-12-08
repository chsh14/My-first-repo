# Create IO delay template.

# This studies the existing constraints on the design and the information produced
# should be used as reference only.
# - This does not constrain source-synchronous interfaces or multicycle IOs correctly.
# - This sets the same IO budget (Same % of fastest clock period of the port) which may not be desirable in all cases.
# - Feedthrough constraining need manual modification.

# To use:
# - Copy this script into your syn/rm_dc_scripts directory
# - Add this line at the end of your constraints.tcl file: source set_io_delays.tcl

# The portion of the clock period which is reserved for the external IO delay
set external_delay 0.45

echo "Creating io.tcl."
echo "" > io.tcl
suppress_message {UID-101 OPT-314 OPT-150 UID-85 TIM-134 TIM-099 TIM-052 TIM-276}
#set in_ports_without_delay [remove_from_collection [all_inputs ] [list [get_ports { *_ahbHMastL*  pcgcBusUp* ck* testBusIn* tck }] [all_inputs -edge_triggered]]]

#set out_ports_without_delay [remove_from_collection [all_outputs ] [list [get_ports {isolate* pcgcBusUp* *_ahbHMaster_* testBusOut* ckApb ck* ahbDapTeal_ahbExtSlaveCk}] [all_outputs  -edge_triggered]]]
#append_to_collection in_ports_without_delay $out_ports_without_delay -unique
set in_ports_without_delay [get_ports peripheralPadBus*]
foreach_in_collection port [get_ports $in_ports_without_delay] {
	set port_dir [get_attribute $port port_direction]
	# Inputs
	if {$port_dir == "in"} {
		set in_paths [get_timing_paths -from $port]
		set stored_clock_period 100000
		foreach_in_coll path $in_paths {
			set clock [get_object_name [get_attribute $path endpoint_clock]]
			set clock_period [get_attribute $clock period]
			if {$clock != ""} {
				if {$clock_period < $stored_clock_period} {
					set stored_clock_period $clock_period
					set stored_clock $clock
					set stored_port [get_object_name $port]
				}
			} else {
				echo "# Warning:" [get_object_name $port] "has no associated clock." >> io.tcl
			}
		}
		if {$stored_clock_period < 100000 && $stored_clock_period != ""} {
			echo "set_input_delay" [expr {$external_delay * $stored_clock_period}] "-clock" $stored_clock "\{$stored_port\}" >> io.tcl
		}

	# Outputs
	} else {
		# Get paths to port
		set out_paths [get_timing_paths -to $port]
		# Loop over all output paths to the port
		foreach_in_collection path $out_paths {
			set startpoint [get_attribute $path startpoint]
			set startpoint_clocks [get_attribute $startpoint clocks]
			if {$startpoint_clocks == ""} {
				echo "# Warning:" [get_object_name $port] "has no associated clock." >> io.tcl
			} else {
				echo "# Debug:" [get_object_name $port] "is launched by clocks:" [get_object_name $startpoint_clocks] >> io.tcl
				# Loop over all startpoint clocks of the port to get the clock period
				set stored_clock_period 100000
				foreach_in_collection clock $startpoint_clocks {
					set clock_period [get_attribute $clock period]
					# Check if the new clock is faster and use that
					if {$clock_period < $stored_clock_period} {
						set stored_clock_period $clock_period
						set stored_clock [get_object_name $clock]
						set stored_port [get_object_name $port]
					}
				}
				if {$stored_clock_period < 100000 && $stored_clock_period != ""} {
					echo "set_output_delay" [expr {$external_delay * $stored_clock_period}] "-clock" $stored_clock "\{$stored_port\}" >> io.tcl
				}
			}
		}
	}
}
unsuppress_message {UID-101 OPT-314 OPT-150 UID-85 TIM-134 TIM-099 TIM-052 TIM-276}
#echo "Applying IO delays. Sourcing script io.tcl."
#source io.tcl






