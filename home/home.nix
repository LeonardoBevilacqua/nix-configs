{ config, pkgs, ... }:

let 
    neovimConfig = import ../shells/dev-env/neovim.nix { inherit pkgs; };
    devtools = import ../shells/dev-env/devtools.nix { inherit pkgs; };
    languages = import ../shells/dev-env/languages.nix { inherit pkgs; };
in
{
  home.username = "leonardo";
  home.homeDirectory = "/home/leonardo";

  home.stateVersion = "25.11"; 

  home.packages = neovimConfig.packages ++ devtools ++ languages;

  home.file = {
  };

  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

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
