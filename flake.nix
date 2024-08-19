{
  description = "flask-example";
  # https://gist.github.com/CMCDragonkai/45359ee894bc0c7f90d562c4841117b5
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
              curl
              bash
              coreutils
              which
            ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            #              installPhase = ''
            #                echo "hello"
            #                mkdir -p $out/bin
            #                echo ${lib.makeBinPath [ pkgs.curl ]} > $out/bin/wtf.txt
            #                echo janei > $out/bin/demo.sh
            #                ls -lrt
            #                '';
            postInstall = ''
              mkdir -p $out/bin
              echo janei > $out/bin/ugg.sh
              echo ${lib.makeBinPath [ pkgs.curl ]} > $out/bin/curl.txt
            '';

          };

          # The default package when a specific package name isn't specified.
          defaultPackage = packages.app;
        };
      in
      myapp
    );
}
