{
  description = "Cursor CLI";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [ cursor-cli ];
    };
  };
}
