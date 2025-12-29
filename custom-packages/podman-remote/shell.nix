let
  nixpkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-25.11") {};
  podmanRemote = import ./podman-remote.nix { inherit (nixpkgs) stdenv fetchzip; };
in
nixpkgs.mkShell {
  buildInputs = [ podmanRemote nixpkgs.podman-compose ];

  shellHook = ''
    alias podman="podman-remote-static-linux_amd64"
    alias podman-compose="podman-compose --podman-path result/bin/podman-remote-static-linux_amd64"
  '';
}

