# Avoids the insanely annoying "Restore pages" prompt that chrome show on startup
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/google-chrome/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' ~/.config/google-chrome/Default/Preferences
google-chrome
