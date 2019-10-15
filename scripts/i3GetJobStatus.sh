#!/bin/bash
source ~/.localConfig
if [[ $systemName == "ita" ]]; then
    USER="hd_hp240"
    output=$(ssh bwprod "~/projects/config/scripts/getJobStatus.sh")
    echo $output
fi
