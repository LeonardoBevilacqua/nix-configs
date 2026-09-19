{
    flake.modules.homeManager.leonardo-bluesun = { config, pkgs, ... }:

    {
        home.username = "leonardo";
        home.homeDirectory = "/home/leonardo";
        programs.git = {
            enable = true;
            settings.user = {
                name = "Leonardo Bevilcqua";
                email = "leonardo_bevilacqua@hotmail.com";
            };
        };
        home.stateVersion = "26.05";
        programs.bash = {
            enable = true;
            shellAliases = {
                btw = "echo i use nixos, btw";
            };
        };
    };
}
