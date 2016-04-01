#Change this command to get the timing path with which you are concerned 

set my_path [get_timing_paths -to u_TempSenseTmx/u_TempSensDig/u_Par/tempSensOut_rg_reg_5_/D -path_type full_clock_expanded] 

set my_points [get_attr $my_path points] 
set my_cells {} 
foreach_in_collection point $my_points { 
  set obj [get_attr $point object] 
  set obj_class [get_attribute $obj object_class] 
  set dir [get_attribute $obj direction] 
  if {$dir == "in" && $obj_class == "pin" } { 
    set my_cells [add_to_collection $my_cells [get_cell -of_object $obj -filter "@is_combinational == true"]] 
  } 
} 
echo "There are [sizeof_collection $my_cells] levels of logic in the path" 

get_flat_cells -of_objects [get_cells -hier *u_*Par* -filter "full_name=~*Nfc*Par"] -filter "is_sequential==true

set collection_result_display_limit 10000