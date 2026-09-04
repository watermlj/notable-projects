onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label Addend1 -radix decimal /testbench/Addend1
add wave -noupdate -label Addend2 -radix decimal /testbench/Addend2
add wave -noupdate -divider AdderSubtractor
quietly WaveActivateNextPane {} 0
add wave -noupdate -label Clock /testbench/Clock
add wave -noupdate -label Reset /testbench/Reset
add wave -noupdate -label Selector /testbench/Selector
add wave -noupdate -label AddSub /testbench/AddSub
quietly WaveActivateNextPane {} 0
add wave -noupdate -label Sum -radix decimal /testbench/Sum
add wave -noupdate -label Overflow /testbench/Overflow
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 73
configure wave -valuecolwidth 64
configure wave -justifyvalue center
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {500 ns}