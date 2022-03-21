
vlib work

vlog buttons_FSM.v

vsim buttons_FSM

log {/*}
add wave {/*}

force clk 1 0ns, 0 {5ns} -r 10ns

force resetn 0
force key_pressed 1
run 10ns
force resetn 1
run 90ns

force key_pressed 0
run 100ns

force key_pressed 1
run 100ns
