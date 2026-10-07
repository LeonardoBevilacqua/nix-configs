{ inputs, ... }:

{
    flake.modules.nixos.sway-desktop = { lib, pkgs, ... }: {
        hardware = {
            # Disables nvidia driverskeeping the nouveau
            nvidia.open = lib.mkForce false;
            nvidia.modesetting.enable = lib.mkForce false;
        };

        services = {
            # Disables cosmic desktop from base
            displayManager = {
                cosmic-greeter.enable = lib.mkForce false;
                ly.enable = true;
            };
            desktopManager.cosmic.enable = lib.mkForce false;
            greetd.enable = lib.mkForce false;
            # set nouveau as driver
            xserver.videoDrivers = lib.mkForce [ "modesetting" "nouveau" ];
        };

        programs = {
            steam.enable = lib.mkForce false;
            sway = {
                enable = true;
                wrapperFeatures.gtk = true;
            };
        };

        security.polkit.enable = true;

        environment = {
            cosmic.excludePackages = lib.mkForce [ ];
            systemPackages = with pkgs; [
                wl-clipboard
                mako
                waybar
                playerctl
            ];
        };
    };
}
