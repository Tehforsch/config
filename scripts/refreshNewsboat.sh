while true; do
    newsboat -u ~/projects/config/newsboat/urls -C ~/projects/config/newsboat/config -x reload
    sleep 7200
done
