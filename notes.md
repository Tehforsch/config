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
## emacs
the native treesit (as opposed to tree-sitter plugins) looks worse than tree-sitter. i implemented the necessary changes to nixos etc on the "add-native-tree-sitter" branch, if i ever wanna check that out again

consult lsp symbols is super slow and ugly. why is it much faster and nicer looking if i do consult lsp symbols file ?

would prefer if i could run cape-dabbrev immediately when no lsp matches are found. CANNOT find out how to do this and suggest not researching it anymore in the future. find a fucking work around if you want but dont try

lsp, flycheck and normal compilation dont work together at all. bacon is really nice so i dont really wanna switch away from it but the discrepancies are really annoying. they happen especially when features exist since flycheck will use different --features than lsp itself which will also use different features than bacon. it would be nice to do ONE compilation and to use the output for everything?? can i use lsp diagnostics in the terminal? 
i hate diagnostics jumping since i have to wait for the lsp results to come in every time and it sucks. the best usability would be to add the ability to save the current file (because i fixed the error) but jump to the next error location before saving it! one idea is to add something to lsp-diagnostics-updated-hook that jumps to the next error immediately when they are received. alternatively we could save the error locations from a previous run somehow. flycheck-error-list is almost ideal, but there is no such thing for all the errors in the workspace :| https://github.com/emacs-lsp/lsp-mode/issues/382 . I even tried switching to eglot for this. Overall I feel like the goto definition/reference performance of eglot was slightly faster, but everything else about the tooling sucked. Initially I loved the flymake-show-project-diagnostics (or whatever the exact name was) command, but it just resulted in stale errors/warnings which caused more problems than they solved. compared to that consult-lsp-diagnostics is actually quite good. getting it to show documentations and errors was a fucking nightmare and i never want to work with eldoc/flymake again tbh. 
i suppose this all becomes a bit better if i dont have anything like bacon running and only use the emacs lsp to get diagnostics

shitty lsp suggestion ordering. it should be fields and methods belonging to the struct first and then anything from traits

sometimes i get a message like "could not assert ownership over selection: CLIPBOARD" when deleting lines and it stops me from deleting the fucking line which is the most triggering shit on earth

custom evil surrounds cannot be repeated with . (function, generic, ...)

magit doesnt work at all anymore

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
