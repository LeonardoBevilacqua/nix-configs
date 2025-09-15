{ pkgs ? import <nixpkgs> {} }:

let 
    neovimConfig = import ./neovim.nix { inherit pkgs; };
    devtools = import ./devtools.nix { inherit pkgs; };
    languages = import ./languages.nix { inherit pkgs; };
in
pkgs.mkShell {
    name = "nvim-dev-env";
    buildInputs = neovimConfig.packages ++ devtools ++ languages;
    shell = "${pkgs.bashInteractive}/bin/bash";
    shellHook = ''
    echo "Sourcing project .bashrc"
    source ${toString ./bashrc}
    ${neovimConfig.shellHook}
    echo "✅ Environment ready!"
    '';
}

