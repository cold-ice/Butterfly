onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /butterfly_tb/Butterfly/LS_CU/CLOCK
add wave -noupdate /butterfly_tb/Butterfly/LS_CU/RESET
add wave -noupdate /butterfly_tb/Butterfly/LS_CU/START
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/LS_CU/INSTRUCTION
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/LS_CU/INSTRUCTION_EVEN
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/LS_CU/INSTRUCTION_ODD
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/LS_CU/NEW_INSTRUCTION
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/LS_CU/INSTRUCTION_BUFFER
add wave -noupdate /butterfly_tb/Butterfly/LS_CU/INSTRUCTION_ADDRESS
add wave -noupdate /butterfly_tb/Butterfly/LS_CU/LSB_uADDRESS
add wave -noupdate /butterfly_tb/Butterfly/LS_CU/JUMP_VALIDATION
add wave -noupdate /butterfly_tb/Butterfly/LS_CU/INSTRUCTION_SEL
add wave -noupdate /butterfly_tb/Butterfly/LS_CU/INSTRUCTION_ADDRESS_BUFFER
add wave -noupdate /butterfly_tb/Butterfly/DP/CLOCK
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/DATA_IN0
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/DATA_IN1
add wave -noupdate /butterfly_tb/Butterfly/DP/RESET
add wave -noupdate /butterfly_tb/Butterfly/DP/CHIP_SELECT
add wave -noupdate /butterfly_tb/Butterfly/DP/WR2
add wave -noupdate /butterfly_tb/Butterfly/DP/WR1
add wave -noupdate /butterfly_tb/Butterfly/DP/WR0
add wave -noupdate /butterfly_tb/Butterfly/DP/BUS0_SEL
add wave -noupdate /butterfly_tb/Butterfly/DP/BUS1_SEL
add wave -noupdate /butterfly_tb/Butterfly/DP/LD1
add wave -noupdate /butterfly_tb/Butterfly/DP/LD2
add wave -noupdate /butterfly_tb/Butterfly/DP/LD3
add wave -noupdate /butterfly_tb/Butterfly/DP/LD4
add wave -noupdate /butterfly_tb/Butterfly/DP/MUX1_SEL
add wave -noupdate /butterfly_tb/Butterfly/DP/MUX2_SEL
add wave -noupdate /butterfly_tb/Butterfly/DP/MUX3_SEL
add wave -noupdate /butterfly_tb/Butterfly/DP/MUX4_SEL
add wave -noupdate /butterfly_tb/Butterfly/DP/MUX5_SEL
add wave -noupdate /butterfly_tb/Butterfly/DP/MUX6_SEL
add wave -noupdate /butterfly_tb/Butterfly/DP/C0_0
add wave -noupdate /butterfly_tb/Butterfly/DP/C0_1
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/DATA_OUT0
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/DATA_OUT1
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/BUS0
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/BUS1
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/BUS2
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/DATA_OUT1_BUFFER
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/MULT_IN0
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/MULT_IN1
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/SHF_IN
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/SHF_OUT
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/ROUNDER_OUT
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/SUM0_IN0
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/SUM0_IN1
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/SUM0_OUT
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/SUM1_IN0
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/SUM1_IN1
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/SUM1_OUT
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/R3_IN
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/R3_OUT
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/MULT_OUT
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/R2_OUT
add wave -noupdate -radix hexadecimal /butterfly_tb/Butterfly/DP/ROUNDER_IN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {99399 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {105 ns}
