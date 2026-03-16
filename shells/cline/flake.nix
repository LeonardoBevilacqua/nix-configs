{
  description = "Cline";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... } @ inputs:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    devShells.x86_64-linux.default = import ./shell.nix {
      inherit pkgs;
      packageLockJson = ./package-lock.json;
    };
  };
}
