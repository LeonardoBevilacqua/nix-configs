{
    flake.modules.homeManager.leodev-bluesun = { config, pkgs, ... }:

    let
      dotfiles = "${config.home.homeDirectory}/dotfiles";
      create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    in
    {
        home.username = "leodev";
        home.homeDirectory = "/home/leodev";
        home.stateVersion = "26.05";
        programs.bash = {
            enable = true;
            shellAliases = {
                bluesun-rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/nix-configs/#nixos-bluesun";
                bluesun-rebuild-sway = "sudo nixos-rebuild switch --flake ~/dotfiles/nix-configs/#nixos-bluesun --specialisation sway";
            };
        };
        xdg.configFile = {
            "sway" = {
                source = create_symlink "${dotfiles}/sway";
                recursive = true;
            };
            "waybar" = {
                source = create_symlink "${dotfiles}/waybar";
                recursive = true;
            };
        };
    };
}
