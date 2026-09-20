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
            };
        };

        xdg.configFile = {
            "nvim" = {
              source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
              recursive = true;
            };
            "tmux" = {
              source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/tmux";
              recursive = true;
            };
            "git" = {
              source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/git";
              recursive = true;
            };
            "lazygit" = {
              source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/lazygit";
              recursive = true;
            };
            "alacritty" = {
              source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/alacritty";
              recursive = true;
            };
        };
    };
}
