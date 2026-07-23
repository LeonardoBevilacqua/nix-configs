{ inputs, config, ... }:
{
  flake.homeConfigurations = {
    "leonardo" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        config.flake.modules.homeManager.common
        config.flake.modules.homeManager.leonardo
      ];
    };

    "leonardobevilacqua" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
      modules = [
        config.flake.modules.homeManager.common
        config.flake.modules.homeManager.leonardobevilacqua
      ];
    };
  };
}
