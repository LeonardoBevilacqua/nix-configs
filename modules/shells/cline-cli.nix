{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.cline-cli = import ../../shells/cline-cli/shell.nix { inherit pkgs; };
  };
}
