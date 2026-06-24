{
  description = "Home Manager configuration of leonardo";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }:
    {
      homeConfigurations."leonardo" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
            {
                home.username = "leonardo";
                home.homeDirectory = "/home/leonardo";
            }
            ./home.nix
        ];
      };
      # home-manager switch --flake .#leonardobevilacqua
      homeConfigurations."leonardobevilacqua" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
            ({ config, ... }: {
                home.username = "leonardobevilacqua";
                home.homeDirectory = "/Users/leonardobevilacqua";
                programs.alacritty.enable = true;
                xdg.configFile = {
                  "alacritty" = {
                      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/alacritty";
                      recursive = true;
                  };
                };
            })
            ./home.nix
        ];
      };
    };
}
