id=$1
cd $(scontrol show job $id | grep WorkDir | sed s/"   WorkDir="/""/)
