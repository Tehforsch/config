# this only installs the custom remote for ur, not ur itself
# restart server (on the dashboard if needed) in order to activate this remote
if [[ ! -d /opt/urserver/remotes/custom ]]; then
    sudo ln -s $CONFIG/unifiedremote/custom /opt/urserver/remotes/
fi
