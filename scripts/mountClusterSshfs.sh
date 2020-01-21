mkdir -p ~/projects/cluster/home
sshfs -odebug hd_hp240@bwprod:/beegfs/home/hd/hd_hd/hd_hp240/projects ~/projects/cluster/home &
mkdir -p ~/projects/cluster/workspace
sshfs -odebug hd_hp240@bwprod:/beegfs/work/ws/hd_hp240-arepoTest-0 ~/projects/cluster/workspace
