ids=$(showq | grep hd_hp240 | tr -s " " | cut -d " " -f 1)
for id in $ids; do
    outfile=$(qstat -f1 $id | tr -s " " | grep Output | cut -f 4 -d " " | cut -d ":" -f 2)
    timestep=$(tail -n 300 "$outfile" | grep "Sync-Point" | tail -n 1)
    echo "Job id: $id, folder: $(dirname $outfile)"
    echo "$timestep"
done
