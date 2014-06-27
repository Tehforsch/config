#set terminal postscript enhanced size 17cm,10cm
set terminal epslatex color size 15cm,15cm

#set size 0.5, 0.5

# color definitions
set border linewidth 1.5
set style line 1 lc rgb '#0060ad' lt 1 lw 6 pt 2 ps 2.5 # --- blue line
set style line 2 lc rgb '#bf1919' lt 1 lw 6 pt 4 ps 2.5 # --- red line
set style line 3 lc rgb '#009900' lt 1 lw 6 pt 6 ps 2.5 # --- green line
set style line 4 lc rgb '#E9D66B' lt 1 lw 6 pt 8 ps 2.5 # --- yellow/brown line

set style line 5 lc rgb '#0060ad' lt 1 lw 4 pt 2 ps 2.5 # --- blue point
set style line 6 lc rgb '#bf1919' lt 1 lw 4 pt 4 ps 2.5 # --- red point
set style line 7 lc rgb '#009900' lt 1 lw 4 pt 6 ps 2.5 # --- green point
set style line 8 lc rgb '#E9D66B' lt 1 lw 4 pt 8 ps 2.5 # --- yellow/brown point

set style line 17 lc rgb '#000000' lt 2 lw 1 pt 8 ps 1.6 # --- grid lines

set style line 21 lc rgb '#000000' lt 3 lw 6 pt 8 ps 1.6 # --- dashed vertical lines

set tics scale 0.75

halfgapsize = 0.015
marginSize = 0.1
#set lmargin at screen 0.1
#set rmargin at screen 0.9
#set bmargin at screen 0.1
#set tmargin at screen 0.9
