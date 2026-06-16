{ config, lib, pkgs, ... }:

let 
    neovimConfig = import ../shells/dev-env/neovim.nix { inherit pkgs; };
    devtools = import ../shells/dev-env/devtools.nix { inherit pkgs; };
    languages = import ../shells/dev-env/languages.nix { inherit pkgs; };

    sharedAliases = {
        ls = "ls --color=auto";
        ll = "ls -l";
        la = "ls -A";
        dev = "nix develop ~/nix-tutorial/nix-configs/shells/dev-env";
        ".." = "cd ..";
    };
    sharedSessionVariables = {
        NIX_SHELL_PRESERVE_PROMPT = 1;
    };
in
{
  home.username = "leonardo";
  home.homeDirectory = "/home/leonardo";

  home.stateVersion = "25.11"; 

  home.packages = neovimConfig.packages ++ devtools ++ languages;

  home.file = {
  };

  xdg.configFile = {
    "nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/leonardo/dotfiles/nvim";
        recursive = true;
    };
    "tmux" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/leonardo/dotfiles/tmux";
        recursive = true;
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
          shellAliases = sharedAliases;
          sessionVariables = sharedSessionVariables;
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

      zsh = {
          enable = true;
          shellAliases = sharedAliases;
          sessionVariables = sharedSessionVariables;
          history.ignoreDups = true;
          history.ignoreSpace = true;
          defaultKeymap = "viins";
          initContent = lib.mkBefore ''
          export JAVA_HOME=$(/usr/libexec/java_home)
          typeset -U path

          path=(
            $HOME/.nix-profile/bin
            /nix/var/nix/profiles/default/bin
            $JAVA_HOME/bin
            $path
          )

          export PATH

          # Zsh equivalent to: bind 'set completion-ignore-case on'
          zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

          # Zsh equivalent to your exact Bash prompt and git status
          autoload -Uz vcs_info
          precmd() { vcs_info }
          zstyle ':vcs_info:git:*' formats '%b'

          # Clean, standard Zsh string interpolation that Nix won't trip over
          PROMPT="''${DEBIAN_CHROOT:+($DEBIAN_CHROOT)}%F{green}%n %F{blue}%1~ %F{yellow}''${vcs_info_msg_0_}%f
          %# "
          '';
      };
  };
}
