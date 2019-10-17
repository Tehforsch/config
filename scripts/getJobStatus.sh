function stripSeconds {
    reversed=$(echo $1 | rev)
    colonIndex=$(expr index $reversed ":")
    echo $(echo ${reversed:$colonIndex:100} | rev)
}

# can't use showq or checkjob via ssh because its an alias, so use full path
output=$(/opt/moab/bin/showq | grep $USER | tr -s " " | cut -f 1 -d " ")
echo -n " Jobs: "
for line in $output; do
    jobId=$line
    state=$(/opt/moab/bin/checkjob $jobId | grep State: | head -n 1 | awk '{print $2}')
    wallTime=$(/opt/moab/bin/checkjob $jobId | grep WallTime: | head -n 1 | awk '{print $2}')
    maxTime=$(/opt/moab/bin/checkjob $jobId | grep WallTime: | head -n 1 | awk '{print $4}')
    colonIndex=$(expr index wallTime ":")
    if [[ $state == "Idle" ]]; then
        echo -n "Queueing "
    elif [[ $state == "Running" ]]; then
        echo -n "Run($(stripSeconds $wallTime)/$(stripSeconds $maxTime)) "
    fi
done

