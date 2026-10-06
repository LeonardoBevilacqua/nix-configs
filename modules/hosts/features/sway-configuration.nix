{ inputs, ... }:

{
    flake.modules.nixos.sway-desktop = { lib, pkgs, ... }: {
        # Disables cosmic desktop from base
        services.displayManager.cosmic-greeter.enable = lib.mkForce false;
        services.desktopManager.cosmic.enable = lib.mkForce false;
        environment.cosmic.excludePackages = lib.mkForce [ ];
        services.greetd.enable = lib.mkForce false;
        programs.steam.enable = lib.mkForce false;
        # Disables nvidia drivers, keeping the nouveau
        hardware.nvidia.open = lib.mkForce false;
        hardware.nvidia.modesetting.enable = lib.mkForce false;
        services.xserver.videoDrivers = lib.mkForce [ "modesetting" "nouveau" ];

        programs.sway = {
            enable = true;
            wrapperFeatures.gtk = true;
        };
        security.polkit.enable = true;
        services.displayManager.ly.enable = true;

        environment.systemPackages = with pkgs; [
            wl-clipboard
            mako
            waybar
            playerctl
        ];
    };
}
