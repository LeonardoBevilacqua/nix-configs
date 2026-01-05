{
	description = "NixOS WSL";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-25.11";
		nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
	};

	outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }: {
		nixosConfigurations.nixos-wsl = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				nixos-wsl.nixosModules.default
				./configuration.nix
                home-manager.nixosModules.home-manager
                {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.leonardo = import ../../home-manager/home.nix;
                        backupFileExtension = "backup";
                    };
                }
			];
		};
	};
}
