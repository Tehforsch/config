# This is a little shitty, but it does the job
read -p "root pw: " -s rootpw
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
branch=$(git rev-parse --abbrev-ref HEAD)
echo $rootpw | ssh -A netcup ~/projects/config/scripts/netcupBuild.sh $branch
