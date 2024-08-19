{
  description = "flask-example";
  # Understanding nix inputs: https://gist.github.com/CMCDragonkai/45359ee894bc0c7f90d562c4841117b5
  # poetry2nix cli.nix: https://github.com/nix-community/poetry2nix/blob/ed52f844c4dd04dde45550c3189529854384124e/cli.nix#L31
  # makeWrapper and makeProgram: https://gist.github.com/CMCDragonkai/9b65cbb1989913555c203f4fa9c23374

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        myapp = with pkgs; rec {
          # Development environment
          devShell = mkShell {
            name = "flask-example";
            nativeBuildInputs = [
              python3
              poetry
            ];
          };

          # Runtime package
          packages.app = poetry2nix.mkPoetryApplication {
            projectDir = ./.;
            propagatedBuildInputs = with pkgs; [
              bash
              coreutils
              curl
              which
            ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postInstall = ''
              mkdir -p $out/bin
              ln -s ${lib.makeBinPath [ bash ]}/bash $out/bin/bash

              wrapProgram $out/bin/bash \
                  --set PATH ${
                    lib.makeBinPath [
                      coreutils
                      curl
                      which
                    ]
                  }
            '';

          };

          # The default package when a specific package name isn't specified.
          defaultPackage = packages.app;
        };
      in
      myapp
    );
}
