#!/bin/sh

requirements_file=pythonModuleList
for module in $(cat $requirements_file); do
    echo $module
    if pip install "$module"; then
    echo "Installed: $module"
else
    echo "ERROR: Could not install $module"
    fi
done
