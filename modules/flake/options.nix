{ lib, ... }:
{
  options.flake.modules = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [
        {
          options = {
            homeManager = lib.mkOption {
              type = lib.types.lazyAttrsOf lib.types.deferredModule;
              default = { };
            };
            nixos = lib.mkOption {
              type = lib.types.lazyAttrsOf lib.types.deferredModule;
              default = { };
            };
          };
        }
      ];
    };
    default = { };
  };
}
