{
  description = "Python GTK environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      pyPkgs = ps: with ps; [
        fastapi
        fastapi-cli
        sqlmodel
        pytest
        requests
        faker
      ];
    in
    {
      devShells = {
        "x86_64-linux" = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              sqlite
              (pkgs.python312.withPackages pyPkgs)
            ];
            shellHook = ''
              echo "Python fastapi devShell loaded"
            '';
          };
        };
      };
    };
}

