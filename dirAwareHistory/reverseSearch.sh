dirAndCommand=$(cat ~/.dirAwareHistory | tac | uniq | fzf --tiebreak=index --with-nth=2.. --delimiter=" ")
split=( $dirAndCommand )

dir="${split[0]}"
command="${split[@]:1}"

pwdBefore=$(pwd)
cd "$dir"
$command
cd "$pwd"

