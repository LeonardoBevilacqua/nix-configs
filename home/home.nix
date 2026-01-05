{ config, pkgs, ... }:

let 
    neovimConfig = import ../shells/dev-env/neovim.nix { inherit pkgs; };
    devtools = import ../shells/dev-env/devtools.nix { inherit pkgs; };
    languages = import ../shells/dev-env/languages.nix { inherit pkgs; };
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "leonardo";
  home.homeDirectory = "/home/leonardo";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = neovimConfig.packages ++ devtools ++ languages;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/leonardo/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs = {
      direnv = {
          enable = true;
          enableBashIntegration = true;
          nix-direnv.enable = true;
      };

      bash = {
          enable = true;
          historyControl = [ "ignoreboth" ];
          shellOptions = [ "histappend" "checkwinsize" "extglob" "globstar" "checkjobs" ];
          shellAliases = {
              ls = "ls --color=auto";
              ll = "ls -l";
              la = "ls -A";
              dev = "nix develop ~/nix-tutorial/nix-configs/shells/dev-env";
              ".." = "cd ..";
          };
          sessionVariables = {
              NIX_SHELL_PRESERVE_PROMPT = 1;
          };
          initExtra = ''
              set -o vi
              bind 'set completion-ignore-case on'

              PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'
              PS1="$DEBIAN_CHROOT"
              PS1="$PS1"'\[\033[01;32m\]\u ' # user in color green
              PS1="$PS1"'\[\033[01;34m\]\W' # current working directory in color blue
              PS1="$PS1"' \[\033[33m\]$PS1_CMD1 ' # git branch
              PS1="$PS1"'\[\033[00m\]\n\$ ' # prompt in new line with color white
          '';
      };
  };
}
