echo "Before: $(jj log | wc -l)"
branch=$1
jj logr -r "branch($branch)"
jj abandon "branch($branch)"
echo "After:  $(jj log | wc -l)"
