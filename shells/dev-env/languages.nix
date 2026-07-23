{ pkgs }:

with pkgs; [
    python3
    lua
    nodejs_22
    # jdk21 # disabled: conflicts with the JDK already managed on the work macOS machine
    gcc
]
