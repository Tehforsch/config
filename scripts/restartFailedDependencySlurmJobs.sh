for id in $(squeue -u tpeter | grep DependencyNever | tr -s " " | cut -f 2 -d " "); do
    depId=$(scontrol show job $id | grep "Dependency" | cut -d ":" -f 2 | sed "s/(failed)//")
    depFolder=$(sacct -n -j $depId -o jobid,workdir%150 | grep -v ".batch" | grep -v ".extern" | tr -s " " | cut -f 2 -d " ")
    echo Restarting $depId at $depFolder
    echo $depFolder
    cd "$depFolder"
    sbatch job
    scontrol update JobId=$id dependency=afterok:$depId
done
