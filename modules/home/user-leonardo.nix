{
  flake.modules.homeManager.leonardo =
    { ... }:
    {
      home.username = "leonardo";
      home.homeDirectory = "/home/leonardo";
    };
}
