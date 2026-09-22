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

        # dark theme in GTK and QT apps
        dconf = {
            enable = true;
            settings = {
                "org/gnome/desktop/interface" = {
                    color-scheme = "prefer-dark";
                    gtk-theme = "adw-gtk3-dark";
                };
            };
        };
        gtk = {
            enable = true;
            theme = {
                name = "adw-gtk3-dark";
                package = pkgs.adw-gtk3;
            };
            gtk3.extraConfig = {
                Settings = ''gtk-application-prefer-dark-theme=1'';
            };
            gtk4.extraConfig = {
              Settings = ''gtk-application-prefer-dark-theme=1'';
            };
        };
        qt = {
            enable = true;
            platformTheme = "gnome";
            style.name = "adwaita-dark";
            style.package = pkgs.adwaita-qt;
        };

        # Set a session variable to reinforce the GTK theme for some apps
        home.sessionVariables.GTK_THEME = "adw-gtk3-dark";
    };
}
