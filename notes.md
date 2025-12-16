# Mouse
use piper to set DPI to 3000

# Raspberry pi
Flash basic image to SD (I tried many times to build a custom SD but the process always ended up consuming terabytes of memory, swapping and crashing).
Attach a keyboard like a caveman, change the user passwd
In the nixos config: Make sure initialPassword or hashedPassword is set for some user!
Use deployNixos script to deploy the config to the rpi, dont build it locally (which is unsurprising). You might need to change the ssh config, since the user is probably "nixos", not "toni"
Reboot the rpi when its done.
Clone the config project and symlink files. Maybe syncthing has created a root-readable ~/.config dir, which is annoying. Delete it i guess


# Annoying things
## wayland / sway
had a ton of problems, so switched back
- electron apps would be really slow sometimes
- electron apps would be unclickable sometimes
- screenshotting didnt work when a screen with fractional scaling was enabled.
- gpu recognition didnt really work a lot of times
- problems with bevy and vulkan libs although i solved them eventually by installing the appropriate packages globalls (probably nixos related)
- really slow performance in bevy games (gpu related issues proably, but it happened on my framework which has an AMD)

## hyprland
I had various issues so I'll probably wait for a while before I switch to it. Activating hyprland.nix and removing i3.nix should switch back.
- Mouse cursor randomly vanished
- Freeze (https://github.com/hyprwm/Hyprland/issues/2789, Issue is closed but I don't think the problem is fixed. Never buying an nvidia graphics card again)
- I didn't like my status bar. The display was ugly compared to i3wsr + i3status. I don't think hyprland-automate-workspace-names is as good as it will be if I just wait a little.
- Emacs didn't focus ( https://github.com/hyprwm/Hyprland/discussions/1793 )
- waybar used a lot of CPU and weirdly lagged if I moused over the workspace names. Yikes
- I didn't like the fullscreen toggle. i3 toggles to tabbed mode so I see the window in fullscreen but it doesn't send a "fullscreen mode" event to the window as hyprland does. This means maximizing a browser, for example, would randomly move around and re-render items in hyprland whereas in i3 it just instantly makes the window bigger which is what I want.

## email
i dont like thunderbird. tried some other stuff:
himalaya: literally crashed on me while trying to send an email (index out of bounds) which wasnt very inspiring. setup was annoying because the versions werent clear and the syntax on the github repo did not actually correspond to what the cargo install-ed binary used. had to go through the wizard.


## thunderbird
in config editor set
mailnews.default_view_flags = 0
to never use threaded
In the Message List view, in the column header, on the far right open the context menu:
At the very bottom is the option:
-> "Apply current view to..."
-> "Folder and its children..."
-> Hover over an account
-> In the next menu don't select a folder. Instead select the account name itself.

## kanata/xmodmap/keyboard
i tried really hard to switch to a new cool config that is more ergonomic for my thumbs than my current l-alt remapped to capslock setup ... it didnt work. i had space+tab mapped to i3 mode (as a chordv2) and tab/rshift as a quick i3 hotkey (which is actually quite nice). i couldnt get used to it and the chord combo sucked. also tab would accidentally not trigger when i wanted it as an individual key if i typed too fast which is, ironically, quite triggering. switched back, but config is still there in git, i just reverted the commit
