# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_param xicom.use_bs_reader 1
create_project -in_memory -part xc7a100tfgg484-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.cache/wt [current_project]
set_property parent.project_path E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_repo_paths e:/vivado/vivadoProjects/IPcores [current_project]
set_property ip_output_repo e:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/ip/prgrom/prgmip32.coe
add_files E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/ip/RAM/dmem32.coe
read_verilog -library xil_defaultlib {
  E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/imports/CPU/ALU.v
  E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/imports/CPU/ControllerIO.v
  E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/imports/CPU/Decoder.v
  E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/imports/CPU/Dmem_UART.v
  E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/imports/CPU/IFetch_UART.v
  E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/imports/CPU/LED.v
  E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/imports/CPU/MemOrIO.v
  E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/imports/CPU/ProgramROM_UART.v
  E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/imports/CPU/Switch.v
  E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/imports/CPU/Tubs.v
  E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/imports/CPU/CPU_UART.v
}
read_ip -quiet E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/ip/RAM/RAM.xci
set_property used_in_implementation false [get_files -all e:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/ip/RAM/RAM_ooc.xdc]

read_ip -quiet E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/ip/prgrom/prgrom.xci
set_property used_in_implementation false [get_files -all e:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/ip/prgrom/prgrom_ooc.xdc]

read_ip -quiet E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/ip/cpuclk/cpuclk.xci
set_property used_in_implementation false [get_files -all e:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/ip/cpuclk/cpuclk_board.xdc]
set_property used_in_implementation false [get_files -all e:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/ip/cpuclk/cpuclk.xdc]
set_property used_in_implementation false [get_files -all e:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/ip/cpuclk/cpuclk_ooc.xdc]

read_ip -quiet E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/sources_1/ip/uart_bmpg_0/uart_bmpg_0.xci

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/constrs_1/imports/CPU/constrains.xdc
set_property used_in_implementation false [get_files E:/vivado/vivadoProjects/CS202_CPU_final/CS202_CPU_final.srcs/constrs_1/imports/CPU/constrains.xdc]


synth_design -top CPU_UART -part xc7a100tfgg484-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef CPU_UART.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file CPU_UART_utilization_synth.rpt -pb CPU_UART_utilization_synth.pb"
