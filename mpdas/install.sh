if [[ ! -a ~/.config/mpdasrc ]]; then
    echo "username = tehforsch" > ~/.config/mpdasrc
    echo "password = PASSWORD" >> ~/.config/mpdasrc
    echo "Fill in password in ~/.config/mpdasrc !"
    sleep 4
fi
