if [ $# -ne 1 ]; then
    echo "Missing parameter : folder name"
else
    mkdir $1
    cd $1
    touch nextActions waiting somedayMaybe timed
    mkdir reference 
    cd ..
fi
