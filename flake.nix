{
  description = "Flakey";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    devshell.url = "github:numtide/devshell/master";
  };
  outputs = { self, nixpkgs, rust-overlay, flake-utils, devshell, ... }:
  let
    overlay = import ./overlay.nix;
  in {
        templates."rust-lite" = { path = ./templates/rust-lite; description = "A light version of rust environment for devlopment"; };
        templates."rust-wasm" = { path = ./templates/rust-wasm; description = "A fat version of rust environment with nodejs for full-stack devlopment"; };
        overlay = final: prev: overlay final prev;
    } //
  flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ devshell.overlay rust-overlay.overlay overlay ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
      {
        devShell = pkgs.devshell.mkShell {
          packages = [
            openssl
            openssl.dev
            pkgconfig
            docker-compose
            wasm-pack
            curl
            jq
            cargo-expand-nightly # wrapped cargo that uses nightly rustc regardless off current toolchain
            cargo-release
            git-cliff
            (rust-bin.stable.latest.default.override {
              extensions = [ "rust-src" ];
              targets = [ "wasm32-unknown-unknown" ];
            })
            rust-analyzer
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

