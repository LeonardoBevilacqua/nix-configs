{ inputs, swayDesktopModule, ... }:

{
    flake.modules.nixos.bluesun = { config, lib, pkgs, swayDesktopModule, ... }:
    {
        imports = [ ./_hardware-configuration.nix ];

        boot = {
            loader = {
                systemd-boot = {
                    enable = true;
                    configurationLimit = 5;
                };
                efi.canTouchEfiVariables = true;
            };
            kernelPackages = pkgs.linuxPackages_latest;

            plymouth = {
              enable = true;
	      theme = "nixos-bgrt";
	      themePackages = with pkgs; [ nixos-bgrt-plymouth ];
            };
            # Enable "Silent boot"
            consoleLogLevel = 3;
            initrd.verbose = false;
            kernelParams = [
              "quiet"
              "rd.udev.log_level=3"
              "rd.systemd.show_status=auto"
            ];
        };

        networking = {
            hostName = "bluesun";
            networkmanager.enable = true;
        };

        time.timeZone = "America/Sao_Paulo";

        i18n = {
            defaultLocale = "en_US.UTF-8";
            extraLocaleSettings = {
                LC_ADDRESS = "pt_BR.UTF-8";
                LC_IDENTIFICATION = "pt_BR.UTF-8";
                LC_NAME = "pt_BR.UTF-8";
                LC_TELEPHONE = "pt_BR.UTF-8";
                LC_TIME = "pt_BR.UTF-8";
                LC_MONETARY = "pt_BR.UTF-8";
                LC_NUMERIC = "pt_BR.UTF-8";
                LC_PAPER = "pt_BR.UTF-8";
                LC_MEASUREMENT = "pt_BR.UTF-8";
            };
        };

        hardware = {
            # GPU
            graphics = {
                enable = true;
                enable32Bit = true;
            };
            nvidia = {
                open = true;
                modesetting.enable = true;
                package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
                    version = "595.91.07";
                    sha256_64bit = "sha256-yiPIjdJLB6GRZE4eEc+3vN11NzBXSa9A+YABiwleYxM=";
                    sha256_aarch64 = "sha256-fqkN7ONFXtTeXyu2mQxorrk362Epxq3bz88hhKYQzwQ=";
                    openSha256 = "sha256-OB8Epd+qn/WywxsPiFpxEOAzlJqb6I1SyRoV3a8l71k=";
                    settingsSha256 = "sha256-QzT8Cw1luuZGP9DUje3HN/0ngiayqHURj+bqPsxlJ5w=";
                    persistencedSha256 = "sha256-3JQBaNmkwxvCXv9q8aHKas6VZM/JjLsuilC2t7ET0u0=";
                };
            };

            bluetooth.enable = lib.mkForce false;
        };

        services = {
            displayManager.cosmic-greeter.enable = true;
            desktopManager.cosmic.enable = true;
            xserver = {
                videoDrivers = [ "nvidia" ];
                xkb = {
                    layout = "us";
                    variant = "altgr_intl";
                };
            };
            openssh.enable = true;
            jellyfin = {
                enable = true;
                openFirewall = true;
            };
        };


        specialisation = {
            sway.configuration = {
                imports = [ swayDesktopModule ];
            };
        };


        users.users = {
            leonardo = {
                isNormalUser = true;
                extraGroups = [ "wheel" ];
            };
            leodev = {
                isNormalUser = true;
                extraGroups = [ "wheel" ];
            };
            jellyfin.extraGroups = [ "video" "render" ];
        };

        programs = {
            firefox.enable = true;
            steam.enable = true;
        };

        environment = {
            cosmic.excludePackages = with pkgs; [ cosmic-term ];
            systemPackages = with pkgs; [
                vim
                alacritty
                git
                heroic
                gimp
            ];
        };

        fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];


        systemd.services.jellyfin = {
            wantedBy = lib.mkForce [ ];
        };

        # Open ports in the firewall.
        # networking.firewall.allowedTCPPorts = [ ... ];
        # networking.firewall.allowedUDPPorts = [ ... ];

        nix = {
            settings.experimental-features = [ "nix-command" "flakes" ];
            gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 30d";
            };
            settings.auto-optimise-store = true;
        };

        system.stateVersion = "26.05";

    };
}
