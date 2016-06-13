#!/bin/zsh

# Run python with the command to print dir($1), just to quickly check the name of functions for certain libraries/objects of python.
# If -i is specified we need to import $1 first.

command=""
while getopts ":i" opt; do
    case $opt in
        i)
            doImport=1
        ;;
        \?)
            echo "Wrong option: -$OPTARG"
            exit 1
        ;;
    esac
done
shift "$((OPTIND-1))" # Shift off the options and optional --.
if [ $# -eq 0 ]; then
    echo "Missing parameter : object/module name"
else
    if [ $doImport -eq 1 ]; then
        command=$command"import $1;"
    fi
    command=$command"print(dir($1))"
    python -c $command
fi
