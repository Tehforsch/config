if [[ $RUST_BACKTRACE == 1 ]]; then
    export RUST_BACKTRACE=0
else
    export RUST_BACKTRACE=1
fi
