if [[ $# == 2 ]]; then
    host=$1
    target_host=$2
else
    echo "Required: Current hostname and target hostname"
    exit 1
fi

scp -r ~/.ssh/id* $host:~/.ssh/

ssh $host 'bash -s' < ./remote.sh $target_host

rsync -ar ~/.thunderbird $host:~/
