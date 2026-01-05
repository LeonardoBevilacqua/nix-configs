{ config, lib, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "leonardo";
  wsl.wslConf.network.hostname = "nixos-wsl";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05"; 
}
