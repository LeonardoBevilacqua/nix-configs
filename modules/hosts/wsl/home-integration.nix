{ inputs, config, ... }:
{
  flake.modules.nixos.wsl =
    { ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
        users.leonardo = {
          imports = [
            config.flake.modules.homeManager.common
            config.flake.modules.homeManager.leonardo
          ];
        };
      };
    };
}
