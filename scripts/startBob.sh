if [[ $# == 1 ]]; then
    echo bob -v start "~/projects/phd/simulations/$1" "~/work/$1"
    ~/projects/bob/target/release/bob -v start ~/projects/phd/simulations/$1 ~/work/$1
else
    echo bob -v start -d "~/projects/phd/simulations/$1" "~/work/$1"
    ~/projects/bob/target/release/bob -v start -d ~/projects/phd/simulations/$1 ~/work/$1
fi
