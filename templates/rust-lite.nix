{
  description = "Minimal Rust Development Environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url  = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    andoriyu = {
      url = "github:andoriyu/flakes";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
  outputs = { self, nixpkgs, rust-overlay, flake-utils, devshell, ... }:
  flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ andoriyu.overlays.devshell rust-overlay.overlay andoriyu.overlay ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        rust = pkgs.rust-bin.fromRustupToolchainFile "rust-toolchain.toml";
      in
      with pkgs;
      {
        devShell = pkgs.devshell.mkShell {
          packages = [
            openssl
            openssl.dev
            pkgconfig
            rust
            rust-analyzer
          ];
          bash = {
            extra = ''
              export LD_INCLUDE_PATH="$DEVSHELL_DIR/include"
              export LD_LIB_PATH="$DEVSHELL_DIR/lib"
              '';
            interactive = '''';
          };
          commands = [];
          env = [
            {
              name = "RUST_SRC_PATH";
              value = "${rust.rust-src}/lib/rustlib/src/rust/library";
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

