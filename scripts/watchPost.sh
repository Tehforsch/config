while [[ 1 ]]; do
    commandFolder="/gpfs/bwfor/home/hd/hd_hd/hd_hp240/projects/commands/"
    localFolder="/gpfs/bwfor/home/hd/hd_hd/hd_hp240/work"
    python /gpfs/bwfor/home/hd/hd_hd/hd_hp240/projects/pybob/main.py watchPost "$commandFolder" "$localFolder"
    sleep 0.5
done
