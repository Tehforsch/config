for repo in config editor molt openvas-scanner/rust sokobrane striputary; do
    dir="~/projects/$repo"
    cd $dir
    git fetch
    cargo test
done
