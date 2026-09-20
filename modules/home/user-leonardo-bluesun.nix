{
    flake.modules.homeManager.leonardo-bluesun = { config, pkgs, ... }:

    {
        home.username = "leonardo";
        home.homeDirectory = "/home/leonardo";
        home.stateVersion = "26.05";
        programs.bash = {
            enable = true;
            shellAliases = {
                bluesun-rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/nix-configs/#nixos-bluesun";
                bluesun-rebuild-sway = "sudo nixos-rebuild switch --flake ~/dotfiles/nix-configs/#nixos-bluesun --specialisation sway";
            };
        };
    };
}
