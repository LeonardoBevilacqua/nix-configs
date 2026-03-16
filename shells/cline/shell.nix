{ pkgs ? import <nixpkgs> {}, packageLockJson ? ./package-lock.json }:

let
  tarball = pkgs.fetchurl {
    url = "https://registry.npmjs.org/cline/-/cline-2.7.1.tgz";
    hash = "sha256-A+5MDpJXWLaUbV08uLDTIfVoGLcZibG/sXTB2x9WtQQ=";
  };
  # npm-deps derivation needs the lockfile in the source; inject it and add dummy man page (not in npm tarball)
  src = pkgs.runCommand "cline-2.7.1-src.tgz" {} ''
    mkdir -p unpacked
    tar xf ${tarball} -C unpacked
    cp ${packageLockJson} unpacked/package/package-lock.json
    mkdir -p unpacked/package/man && touch unpacked/package/man/cline.1
    tar czf $out -C unpacked .
  '';

  cline = pkgs.buildNpmPackage rec {
    pname = "cline";
    version = "2.7.1";

    inherit src;

    dontNpmBuild = true;
    npmFlags = [ "--ignore-scripts" ];
    npmInstallFlags = [ "--omit=dev" ];

    npmDepsHash = "sha256-+32X5VnCzxEAkgizjSVAeX7I++WsamLi4ZsvjV4ju70=";

    meta = with pkgs.lib; {
      description = "Cline CLI - autonomous coding agent";
      homepage = "https://cline.bot";
      license = licenses.asl20;  # Apache-2.0, per package.json
    };
  };
in
pkgs.mkShell {
  buildInputs = [
    cline
    pkgs.ripgrep  # runtime: @vscode/ripgrep looks for `rg` in PATH
  ];
  shellHook = ''
  export SHELL=${pkgs.bashInteractive}/bin/bash
  '';
}
