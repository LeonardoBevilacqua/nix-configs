{
    flake.modules.homeManager.leodev-bluesun = { config, pkgs, ... }:

    let
      dotfiles = "${config.home.homeDirectory}/dotfiles";
      create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
      neovimConfig = import ../../shells/dev-env/neovim.nix { inherit pkgs; };
      devtools = import ../../shells/dev-env/devtools.nix { inherit pkgs; };
    in
    {
        home.username = "leodev";
        home.homeDirectory = "/home/leodev";
        home.stateVersion = "26.05";
        home.packages = neovimConfig.packages ++ devtools ++ [ pkgs.lua ];
        programs.bash = {
            enable = true;
            historyControl = [ "ignoreboth" ];
            shellOptions = [ "histappend" "checkwinsize" "extglob" "globstar" "checkjobs" ];
            shellAliases = {
                ls = "ls --color=auto";
                bluesun-rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/nix-configs/#nixos-bluesun";
                bluesun-rebuild-sway = "sudo nixos-rebuild switch --flake ~/dotfiles/nix-configs/#nixos-bluesun --specialisation sway";
            };
            initExtra = ''
                bind 'set completion-ignore-case on'

                PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'
                PS1='\[\033[01;32m\]\u ' # user in color green
                PS1="$PS1"'\[\033[01;34m\]\W' # current working directory in color blue
                PS1="$PS1"' \[\033[33m\]$PS1_CMD1 ' # git branch
                PS1="$PS1"'\[\033[00m\]\n\$ ' # prompt in new line with color white
            '';
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
