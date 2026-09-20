{
    flake.modules.homeManager.dotfiles =
        { config, lib, pkgs, ... }:
        let
          dotfiles = "${config.home.homeDirectory}/dotfiles";
          create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
        in
        {
            xdg.configFile = {
                "nvim" = {
                    source = create_symlink "${dotfiles}/nvim";
                    recursive = true;
                };
                "tmux" = {
                  source = create_symlink "${dotfiles}/tmux";
                  recursive = true;
                };
                "git" = {
                  source = create_symlink "${dotfiles}/git";
                  recursive = true;
                };
                "lazygit" = {
                  source = create_symlink "${dotfiles}/lazygit";
                  recursive = true;
                };
                "alacritty" = {
                  source = create_symlink "${dotfiles}/alacritty";
                  recursive = true;
                };
            };
        };
}
