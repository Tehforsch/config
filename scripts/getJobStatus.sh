function stripSeconds {
    reversed=$(echo $1 | rev)
    colonIndex=$(expr index $reversed ":")
    echo $(echo ${reversed:$colonIndex:100} | rev)
}

# can't use showq or checkjob via ssh because its an alias, so use full path
output=$(/opt/moab/bin/showq | grep $USER | tr -s " " | cut -f 1 -d " ")

hasJobs=0
for line in $output; do
    hasJobs=1
done

if [[ $hasJobs -eq 1 ]]; then
    echo -n " Jobs: "
else
    echo -n " No Jobs. "
fi
for line in $output; do
    jobId=$line
    state=$(/opt/moab/bin/checkjob $jobId | grep State: | head -n 1 | awk '{print $2}')
    wallTime=$(/opt/moab/bin/checkjob $jobId | grep WallTime: | head -n 1 | awk '{print $2}')
    maxTime=$(/opt/moab/bin/checkjob $jobId | grep WallTime: | head -n 1 | awk '{print $4}')
    colonIndex=$(expr index wallTime ":")
    if [[ $state == "Idle" ]]; then
        echo -n "Queue "
    elif [[ $state == "Running" ]]; then
        echo -n "Run($(stripSeconds $wallTime)/$(stripSeconds $maxTime)) "
    fi
done

