{
  flake.modules.homeManager.leonardobevilacqua =
    { config, pkgs, ... }:
    {
      home.username = "leonardobevilacqua";
      home.homeDirectory = "/Users/leonardobevilacqua";
      home.packages = with pkgs; [ gh postgresql ];
      programs.alacritty.enable = true;
      xdg.configFile = {
        "alacritty" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/alacritty";
          recursive = true;
        };
      };
    };
}
