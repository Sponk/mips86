
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name KeyboardInterface -dir "/home/yannick/Projekte/verilog/mips86/platform/basys2/KeyboardInterface/planAhead_run_1" -part xc3s250ecp132-4
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "/home/yannick/Projekte/verilog/mips86/platform/basys2/KeyboardInterface/KeyboardInterface.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/yannick/Projekte/verilog/mips86/platform/basys2/KeyboardInterface} }
set_property target_constrs_file "PS2Constraints.ucf" [current_fileset -constrset]
add_files [list {PS2Constraints.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "/home/yannick/Projekte/verilog/mips86/platform/basys2/KeyboardInterface/KeyboardInterface.ncd"
if {[catch {read_twx -name results_1 -file "/home/yannick/Projekte/verilog/mips86/platform/basys2/KeyboardInterface/KeyboardInterface.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"/home/yannick/Projekte/verilog/mips86/platform/basys2/KeyboardInterface/KeyboardInterface.twx\": $eInfo"
}
