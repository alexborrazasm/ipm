{
  description = "Flutter + Dart development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        flutter
        dart
        android-tools
        jdk
      ];

      shellHook = ''
        echo "🚀 Flutter + Dart devShell loaded"
        flutter --version
      '';
    };
  };
}
