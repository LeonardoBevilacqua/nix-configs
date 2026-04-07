{ pkgs ? import <nixpkgs> { } }:

let
  src = pkgs.fetchFromGitHub {
    owner = "cline";
    repo = "cline";
    rev = "v2.13.0-cli";
    hash = "sha256-cpLj2Mb+M8boFjC3TjuB3AMKfS36LqDiWzwMpeeSlLU=";
  };
  srcName = builtins.baseNameOf (toString src);
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs_22
    python3
    gcc
    gnumake
    pkg-config
    sqlite
    git
    ripgrep
  ];

  shellHook = ''
    export CLINE_SRC=${src}
    export CLINE_ROOT="''${XDG_CACHE_HOME:-$HOME/.cache}/cline-cli-v2.13.0/${srcName}"
    export SHELL=${pkgs.bashInteractive}/bin/bash

    _cline_cli_bootstrap() {
      if [ -f "$CLINE_ROOT/.cline-cli-shell-ready" ] \
        && [ -f "$CLINE_ROOT/cli/dist/cli.mjs" ]; then
        return 0
      fi
      echo "cline-cli shell: first-time setup (copy source, npm install, build) — can take several minutes..."
      rm -rf "$CLINE_ROOT"
      mkdir -p "$CLINE_ROOT"
      cp -aT "$CLINE_SRC/." "$CLINE_ROOT/"
      chmod -R u+w "$CLINE_ROOT"
      (
        cd "$CLINE_ROOT" || exit 1
        export HUSKY=0
        npm install
        npm run protos
        npm run cli:build:production
      ) || {
        echo "cline-cli shell: setup failed; remove $CLINE_ROOT and open a new shell to retry." >&2
        return 1
      }
      touch "$CLINE_ROOT/.cline-cli-shell-ready"
    }

    _cline_cli_bootstrap || true

    cline() {
      node "$CLINE_ROOT/cli/dist/cli.mjs" "--tui" "$@"
    }
    export -f cline
  '';
}
