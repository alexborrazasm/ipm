{
  description = "Python GTK environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      pyPkgs = ps: with ps; [
        pygobject3
      ];
    in
    {
      devShells = {
        "x86_64-linux" = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              libadwaita
              gtk4
              graphene
              glib
              gobject-introspection
              (pkgs.python312.withPackages pyPkgs)
            ];
            shellHook = ''
              export LD_LIBRARY_PATH=${pkgs.gtk4}/lib:$LD_LIBRARY_PATH
              echo "Python + GTK devShell loaded"
            '';
          };
        };
      };
    };
}

