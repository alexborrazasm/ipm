{
  description = "Python GTK environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      pyPkgs = ps: with ps; [
        requests
        pygobject3
        pylint
      ];
    in
    {
      devShells = {
        "x86_64-linux" = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # Python with packages
              (python312.withPackages pyPkgs)
              
              # Dev tools
              gobject-introspection
              gtk4
              libadwaita
              wrapGAppsHook
            ];

            shellHook = ''
              echo "Python+GTK+adwaita devShell loaded"
            '';
          };
        };
      };
    };
}
