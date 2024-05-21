set -e

JOURNAL_PATH=~/resource/journal

date=$(date --date="$@" +%Y-%m-%d)

folder=$JOURNAL_PATH/$date
entry=$folder/entry.md
pics=$folder/pics

mkdir -p $folder
if [  ! -f $entry ]; then
    touch $entry
fi
mkdir -p $pics
emacsclient -c -n $entry

