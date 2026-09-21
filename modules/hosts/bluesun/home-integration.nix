{ inputs, config, ... }:

{
    flake.modules.nixos.bluesun = { ... }:
    {
        imports = [ inputs.home-manager-stable.nixosModules.home-manager ];

        home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            users.leonardo = {
                imports = [
                    # config.flake.modules.homeManager.common
                    config.flake.modules.homeManager.dotfiles
                    config.flake.modules.homeManager.leonardo-bluesun
                ];
            };
        };

        specialisation = {
            sway.configuration = {
                home-manager.users.leodev = {
                    imports = [
                        # config.flake.modules.homeManager.dotfiles
                        config.flake.modules.homeManager.leodev-bluesun
                    ];
                };
            };
        };
    };
}
