{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.dotnet7-dev = pkgs.mkShell {
      buildInputs = with pkgs; [ dotnetCorePackages.sdk_7_0_3xx-bin mono ];
    };
  };
}
