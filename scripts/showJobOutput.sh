id=$1
tail -f $(scontrol show job $id | grep StdOut | sed s/"   StdOut="/""/)
