onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fft_but_comp_tb/BUT/iCLK
add wave -noupdate -color Gold -height 34 /fft_but_comp_tb/BUT/iBUT_SEL
add wave -noupdate -radix decimal /fft_but_comp_tb/BUT/iX0_RE
add wave -noupdate -radix decimal /fft_but_comp_tb/BUT/iX0_IM
add wave -noupdate -radix decimal /fft_but_comp_tb/BUT/iX1_RE
add wave -noupdate -radix decimal /fft_but_comp_tb/BUT/iX1_IM
add wave -noupdate -radix decimal /fft_but_comp_tb/BUT/iX2_RE
add wave -noupdate -radix decimal /fft_but_comp_tb/BUT/iX2_IM
add wave -noupdate -radix decimal /fft_but_comp_tb/BUT/iX3_RE
add wave -noupdate -radix decimal /fft_but_comp_tb/BUT/iX3_IM
add wave -noupdate -radix decimal -childformat {{{/fft_but_comp_tb/BUT/re_buf[0]} -radix decimal} {{/fft_but_comp_tb/BUT/re_buf[1]} -radix decimal} {{/fft_but_comp_tb/BUT/re_buf[2]} -radix decimal} {{/fft_but_comp_tb/BUT/re_buf[3]} -radix decimal}} -subitemconfig {{/fft_but_comp_tb/BUT/re_buf[0]} {-height 15 -radix decimal} {/fft_but_comp_tb/BUT/re_buf[1]} {-height 15 -radix decimal} {/fft_but_comp_tb/BUT/re_buf[2]} {-height 15 -radix decimal} {/fft_but_comp_tb/BUT/re_buf[3]} {-height 15 -radix decimal}} /fft_but_comp_tb/BUT/re_buf
add wave -noupdate -radix decimal -childformat {{{/fft_but_comp_tb/BUT/im_buf[0]} -radix decimal} {{/fft_but_comp_tb/BUT/im_buf[1]} -radix decimal} {{/fft_but_comp_tb/BUT/im_buf[2]} -radix decimal} {{/fft_but_comp_tb/BUT/im_buf[3]} -radix decimal}} -subitemconfig {{/fft_but_comp_tb/BUT/im_buf[0]} {-height 15 -radix decimal} {/fft_but_comp_tb/BUT/im_buf[1]} {-height 15 -radix decimal} {/fft_but_comp_tb/BUT/im_buf[2]} {-height 15 -radix decimal} {/fft_but_comp_tb/BUT/im_buf[3]} {-height 15 -radix decimal}} /fft_but_comp_tb/BUT/im_buf
add wave -noupdate -height 34 -group {4 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY0_RE
add wave -noupdate -height 34 -group {4 DOT} -radix binary /fft_but_comp_tb/Y0_RE_4DOT
add wave -noupdate -height 34 -group {4 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY0_IM
add wave -noupdate -height 34 -group {4 DOT} -radix binary /fft_but_comp_tb/Y0_IM_4DOT
add wave -noupdate -height 34 -group {4 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY1_RE
add wave -noupdate -height 34 -group {4 DOT} -radix binary /fft_but_comp_tb/Y1_RE_4DOT
add wave -noupdate -height 34 -group {4 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY1_IM
add wave -noupdate -height 34 -group {4 DOT} -radix binary /fft_but_comp_tb/Y1_IM_4DOT
add wave -noupdate -height 34 -group {4 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY2_RE
add wave -noupdate -height 34 -group {4 DOT} -radix binary /fft_but_comp_tb/Y2_RE_4DOT
add wave -noupdate -height 34 -group {4 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY2_IM
add wave -noupdate -height 34 -group {4 DOT} -radix binary /fft_but_comp_tb/Y2_IM_4DOT
add wave -noupdate -height 34 -group {4 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY3_RE
add wave -noupdate -height 34 -group {4 DOT} -radix binary /fft_but_comp_tb/Y3_RE_4DOT
add wave -noupdate -height 34 -group {4 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY3_IM
add wave -noupdate -height 34 -group {4 DOT} -radix binary /fft_but_comp_tb/Y3_IM_4DOT
add wave -noupdate -height 34 -expand -group {2 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY0_RE
add wave -noupdate -height 34 -expand -group {2 DOT} -radix binary /fft_but_comp_tb/Y0_RE_2DOT
add wave -noupdate -height 34 -expand -group {2 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY0_IM
add wave -noupdate -height 34 -expand -group {2 DOT} -radix binary /fft_but_comp_tb/Y0_IM_2DOT
add wave -noupdate -height 34 -expand -group {2 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY1_RE
add wave -noupdate -height 34 -expand -group {2 DOT} -radix binary /fft_but_comp_tb/Y1_RE_2DOT
add wave -noupdate -height 34 -expand -group {2 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY1_IM
add wave -noupdate -height 34 -expand -group {2 DOT} -radix binary /fft_but_comp_tb/Y1_IM_2DOT
add wave -noupdate -height 34 -expand -group {2 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY2_RE
add wave -noupdate -height 34 -expand -group {2 DOT} -radix binary /fft_but_comp_tb/Y2_RE_2DOT
add wave -noupdate -height 34 -expand -group {2 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY2_IM
add wave -noupdate -height 34 -expand -group {2 DOT} -radix binary /fft_but_comp_tb/Y2_IM_2DOT
add wave -noupdate -height 34 -expand -group {2 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY3_RE
add wave -noupdate -height 34 -expand -group {2 DOT} -radix binary /fft_but_comp_tb/Y3_RE_2DOT
add wave -noupdate -height 34 -expand -group {2 DOT} -color {Slate Blue} -radix binary /fft_but_comp_tb/BUT/oY3_IM
add wave -noupdate -height 34 -expand -group {2 DOT} -radix binary /fft_but_comp_tb/Y3_IM_2DOT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {400 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 136
configure wave -valuecolwidth 163
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
configure wave -timelineunits us
update
WaveRestoreZoom {346 ns} {450 ns}
