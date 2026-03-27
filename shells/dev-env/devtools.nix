{ pkgs }:

with pkgs; [
    git 
    unzip
    tmux
    pnpm
    bashInteractive
    gnumake
    # direnv moved to env or home manager
]
