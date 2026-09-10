{ inputs, config, ... }:
{
  flake.nixosConfigurations = {
    nixos-wsl = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ config.flake.modules.nixos.wsl ];
    };

    nixos-graphical = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ config.flake.modules.nixos.graphical ];
    };
  };
}
