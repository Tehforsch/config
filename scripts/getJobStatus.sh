# can't use showq or checkjob via ssh because its an alias, so use full path
output=$(/opt/moab/bin/showq | grep $USER | tr -s " " | cut -f 1 -d " ")
for line in $output; do
    jobId=$line
    state=$(/opt/moab/bin/checkjob $jobId | grep State: | head -n 1 | awk '{print $2}')
    wallTime=$(/opt/moab/bin/checkjob $jobId | grep WallTime: | head -n 1 | awk '{print $2}')
    echo -n "$state($wallTime) "
done
