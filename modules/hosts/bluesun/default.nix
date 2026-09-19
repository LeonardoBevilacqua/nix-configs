{ inputs, ... }:

{
    flake.modules.nixos.bluesun = { config, lib, pkgs, ... }:
    {
      imports = [ ./_hardware-configuration.nix ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.kernelPackages = pkgs.linuxPackages_latest;

      networking.hostName = "bluesun";
      networking.networkmanager.enable = true;

      time.timeZone = "America/Sao_Paulo";

      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_TIME = "pt_BR.UTF-8";
          LC_MONETARY = "pt_BR.UTF-8";
          LC_NUMERIC = "pt_BR.UTF-8";
          LC_PAPER = "pt_BR.UTF-8";
          LC_MEASUREMENT = "pt_BR.UTF-8";
        };
      };

      services.displayManager.cosmic-greeter.enable = true;
      services.desktopManager.cosmic.enable = true;
      environment.cosmic.excludePackages = with pkgs; [
        cosmic-term
      ];

      services.xserver.xkb = {
        layout = "us";
        variant = "altgr_intl";
      };

      users.users.leonardo = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };

      programs.firefox.enable = true;

      environment.systemPackages = with pkgs; [
         vim
         alacritty
         git
       ];

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];

      services.openssh.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];

      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      nix.settings.auto-optimise-store = true;
      boot.loader.systemd-boot.configurationLimit = 5;

      system.stateVersion = "26.05";

    };
}
