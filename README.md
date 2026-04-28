# Nix configuration

This repo holds my current nix configuration, separating by:
- Custom packages;
- Home manager users;
- Hosts;
- Custom shells.

## Useful commands

`nix flake update` - Update the flake lock file.
`nix run home-manager -- switch --flake .#leonardo` - Update the home manager derivation.
