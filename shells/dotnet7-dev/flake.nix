{
  description = "Plugin dependencies";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
        inherit system;
        config = {
            permittedInsecurePackages = [ "dotnet-sdk-7.0.317" ];
        };
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [ dotnetCorePackages.sdk_7_0_3xx-bin mono ];
    };
  };
}
