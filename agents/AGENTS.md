# Style
Please remember that I don't want you to add comments that repeat what the code is doing. Comments should only be added for public types or for documenting design decisions that are not obvious from the code.

# Nixos
I'm on NixOS, so when writing bash files, use the shebang
#!/usr/bin/env bash

Also keep this in mind when recommending programs to me or suggesting to install programs.

If working on a project requires specific setup like installed packages, consider adding a dev shell in ~/projects/config/nixos/shells and loading it through direnv/envrc.

# Python
When you write me a python script, please make its dependencies inline so I can simply `uv run script.py` instead of adding the python deps to some shell

# jujutsu
For version control, I use `jj` instead of `git`, which means sometimes things might look slightly different than what you expect. Also you might be running on a jj workspace, in which case .git doesnt exist but you can still check VC with `jj`
