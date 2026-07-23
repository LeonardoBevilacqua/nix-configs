{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.cline = import ../../shells/cline/shell.nix {
      inherit pkgs;
      packageLockJson = ../../shells/cline/package-lock.json;
    };
  };
}
