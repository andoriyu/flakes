{
  description = "Flakey";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell.url = "github:numtide/devshell/master";
    nix-dart.url = "github:tadfisher/nix-dart";
  };
  outputs = { self, nixpkgs, flake-utils, devshell, nix-dart, fenix, ... }:
  let
    overlay = import ./overlay.nix;
    systems = [ "x86_64-linux" "aarch64-linux"];
  in {
        templates."rust-lite" = { path = ./templates/rust-lite; description = "A light version of rust environment for devlopment"; };
        templates."rust-wasm" = { path = ./templates/rust-wasm; description = "A fat version of rust environment with nodejs for full-stack devlopment"; };
        templates."fat" = { path = ./templates/rust-wasm; description = "A fat version of development environment. Right now rust-wasm + some extra packages"; };
    } //
  flake-utils.lib.eachSystem systems (system:
      let
        overlays = [ nix-dart.overlay devshell.overlay overlay ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        rustPlatform = (pkgs.makeRustPlatform {
          inherit (fenix.packages.${system}.minimal) cargo rustc;
        });
      in
      with pkgs;
      {
        packages = rec {
          atlas = callPackage ./packages/atlas/default.nix {};
          inherit cargo-expand-nightly;
          dart-sass = dart-sass-1_52_1;
          git-cliff = callPackage ./packages/git-cliff { inherit rustPlatform; };
          dart-sass-1_52_1 = callPackage ./packages/dart-sass/from-source.nix {
              buildDartPackage = nix-dart.builders.${system}.buildDartPackage;
              version = "1.52.1";
              sha256 = "sha256-fgxiAP8WbSqpLyod4aLK1pQpVtwEhF5ZYpUeheQNvVA=";
              lockFile = ./packages/dart-sass/1_52_1/pub2nix.lock;
          };

          dart-sass-1_49_9 = callPackage ./packages/dart-sass/from-source.nix {
              buildDartPackage = nix-dart.builders.${system}.buildDartPackage;
              version = "1.49.9";
              sha256 = "sha256-FBcXlurgVDqcVPWPpXR2SGBc4SestGv9yovkFmiW5Gs=";
              lockFile = ./packages/dart-sass/1_49_9/pub2nix.lock;
          };
        };
        devShell = pkgs.devshell.mkShell {
          packages = [
            binutils
            openssl
            openssl.dev
            pkgconfig
            docker-compose
            wasm-pack
            curl
            jq
            cargo-release
            git-cliff
            atlas
            (rust-bin.stable.latest.default.override {
              extensions = [ "rust-src" ];
            })
          ];
          bash = {
            extra = ''
              export LD_INCLUDE_PATH="$DEVSHELL_DIR/include"
              export LD_LIB_PATH="$DEVSHELL_DIR/lib"
              '';
            interactive = '''';
          };
          commands = [
            {
              name = "up";
              category = "docker";
              command = "docker-compose up -d";
            }
            {
              name = "down";
              category = "docker";
              command = "docker-compose down";
            }
            {
              name = "restart";
              category = "docker";
              command = "docker-compose restart";
            }
            {
              name = "yarn";
              category = "javascript";
              package = "yarn";
            }
            {
              name = "node";
              category = "javascript";
              package = "nodejs-16_x";
            }
            {
              name = "exa";
              category = "utility";
              package = "exa";
            }
            {
              name = "fd";
              category = "utility";
              package = "fd";
            }
            {
              name = "rg";
              category = "utility";
              package = "ripgrep";
            }

          ];
          env = [
            {
              name = "RUST_SRC_PATH";
              value = "${rust-bin.stable.latest.rust-src}/lib/rustlib/src/rust/library";
            }
            {
              name = "NODE_ENV";
              value = "development";
            }
            {
              name = "OPENSSL_DIR";
              value = "${openssl.bin}/bin";
            }

            {
              name = "OPENSSL_LIB_DIR";
              value = "${openssl.out}/lib";
            }

            {
              name = "OPENSSL_INCLUDE_DIR";
              value = "${openssl.out.dev}/include";
            }
          ];
        };
      }
    );
}

