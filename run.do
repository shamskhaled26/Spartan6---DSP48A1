vlib work
vlog project_DSP.v reg_to_mux.v project_DSP_tb.v
vsim -voptargs=+acc work.project_DSP_tb
add wave *
run -all
#quit -sim