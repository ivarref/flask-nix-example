{
  description = "flask-example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        myapp = with pkgs; rec {
            # Development environment
            devShell = mkShell {
              name = "flask-example";
              nativeBuildInputs = [ python3 poetry ];
            };

            # Runtime package
            packages.app = poetry2nix.mkPoetryApplication {
              projectDir = ./.;
              propagatedBuildInputs = with pkgs; [ curl bash ];
            };

            # The default package when a specific package name isn't specified.
            defaultPackage = packages.app;
        };
      in
        myapp
    );
}
