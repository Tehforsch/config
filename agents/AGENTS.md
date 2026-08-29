# Style
Please remember that I don't want you to add comments that repeat what the code is doing. Comments should only be added for public types or for documenting design decisions that are not obvious from the code.

# Nixos
I'm on NixOS, so when writing bash files, use the shebang
#!/usr/bin/env bash

Also keep this in mind when recommending programs to me or suggesting to install programs.

Please always use flakes for things you write for me to use. For things you just need yourself feel free to use whatever you want, do all the nix-shell in the world

# jujutsu
For version control, I use `jj` instead of `git`, which means sometimes things might look slightly different than what you expect. Also you might be running on a jj workspace, in which case .git doesnt exist but you can still check VC with `jj`
