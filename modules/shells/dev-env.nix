{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.dev-env = import ../../shells/dev-env/default.nix { inherit pkgs; };
  };
}
