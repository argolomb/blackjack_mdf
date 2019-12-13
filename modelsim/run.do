restart
run 1200ns
force -freeze sim:/blackjack_states_tb/blackjack_dut/hit St1 0 -cancel 100

run 100ns
run 100ns
run 100ns

force -freeze sim:/blackjack_states_tb/blackjack_dut/stay St1 0 -cancel 100

run 100ns