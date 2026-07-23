{
  flake.modules.homeManager.leonardobevilacqua =
    { config, ... }:
    {
      home.username = "leonardobevilacqua";
      home.homeDirectory = "/Users/leonardobevilacqua";
      programs.alacritty.enable = true;
      xdg.configFile = {
        "alacritty" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/alacritty";
          recursive = true;
        };
      };
    };
}
