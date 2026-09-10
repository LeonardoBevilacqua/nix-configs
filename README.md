# Nix configuration

My Nix configuration, structured with the [dendritic pattern](https://github.com/mightyiam/dendritic):
a single flake whose modules under `modules/` are auto-imported with
[`import-tree`](https://github.com/vic/import-tree) and composed via
[`flake-parts`](https://flake.parts).

## Layout

- `flake.nix` — entry point; imports every module under `modules/`.
- `modules/flake/` — flake-wide wiring (systems, `flake.modules` option).
- `modules/home/` — Home Manager: `common` config, per-user modules, and the
  `homeConfigurations` outputs.
- `modules/hosts/` — NixOS hosts (`wsl`, `graphical`) and their
  `nixosConfigurations` outputs.
- `modules/shells/` — `devShells` (`dev-env`, `cline`, `cline-cli`,
  `cursor-cli`, `dotnet7-dev`).
- `shells/` — plain source files (shell derivations, neovim/devtools/language
  package lists) imported by the modules above.

## Useful commands

- `nix flake update` — update the flake lock file.
- `nix run home-manager -- switch --flake .#leonardo` — apply the Home Manager
  config (use `.#leonardobevilacqua` on macOS).
- `sudo nixos-rebuild switch --flake .#nixos-wsl` — apply a NixOS host config.
- `nix develop .#dev-env` — enter a dev shell (also aliased as `dev`).
