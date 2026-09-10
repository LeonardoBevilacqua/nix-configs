{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.cursor-cli = pkgs.mkShell {
      buildInputs = with pkgs; [ cursor-cli ];
    };
  };
}
