id=$1
tail -n 100 -f $(scontrol show job $id | grep StdOut | sed s/"   StdOut="/""/)
