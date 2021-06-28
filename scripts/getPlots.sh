simName=$(basename $(realpath .))
rsync -rv bwprod:/gpfs/bwfor/work/ws/hd_hp240-restore/$simName/pics .
