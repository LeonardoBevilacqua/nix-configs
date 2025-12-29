{ stdenv, fetchzip }:

let
  version = "4.9.1"; 
in 
stdenv.mkDerivation {
  pname = "podman-remote";
  inherit version;

  src = fetchzip {
    url = "https://github.com/containers/podman/releases/download/v${version}/podman-remote-static-linux_amd64.tar.gz";
    sha256 = "sha256-yOy22CkevzYadcgwToRWYeNMbivyd9DK3QtfWc6+SxY=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp -r $src/* $out/bin
  '';

  meta = {
    description = "Static Podman remote client";
    homepage = "https://podman.io";
    platforms = [ "x86_64-linux" ];
  };
}

