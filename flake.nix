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
  {
        templates."rust-lite" = { path = ./templates/rust-lite; description = "A light version of rust environment for devlopment"; };
        templates."rust-wasm" = { path = ./templates/rust-wasm; description = "A fat version of rust environment for front-end devlopment"; };
    } //
  flake-utils.lib.eachDefaultSystem (system:
      let
        overlay = final: prev: {
          cargo-expand-nightly = let
            pname = "cargo-expand";
            version = final.cargo-expand.version;
            cargo-expand = final.cargo-expand;
          in final.runCommand "${pname}-${version}" {
              inherit pname version;
              inherit (cargo-expand) src meta;
              nativeBuildInputs = [ final.makeWrapper ];
          } ''
            mkdir -p $out/bin
            makeWrapper ${final.cargo-expand}/bin/cargo-expand $out/bin/cargo-expand \
              --prefix PATH : ${final.pkgs.rust-bin.nightly.latest.minimal}/bin
          '';
          git-cliff = let
            base = pkgs.rust-bin.stable.latest;
            rustPlatform = pkgs.recurseIntoAttrs (pkgs.makeRustPlatform {
              rustc = base.minimal;
              cargo = base.minimal;
            });
          in rustPlatform.buildRustPackage rec {
            pname = "git-cliff";
            version = "0.4.2";

            doCheck = false;

            src = final.fetchFromGitHub {
              owner = "orhun";
              repo = pname;
              rev = "v${version}";
              sha256 = "sha256-FCBNm51QI1jDdq2BZFwZA1kpIfXIvh1ickmY3ZqwGPY=";
            };

            cargoSha256 = "sha256-CBCyujJHWTatJO+Tk6MyOk12B0cY1JSwLQizjcXeQzQ=";

            meta = with final.lib; {
              description = "git-cliff can generate changelog files from the Git history by utilizing conventional commits as well as regex-powered custom parsers. The changelog template can be customized with a configuration file to match the desired format.";
              homepage = "https://github.com/orhun/git-cliff";
              license = licenses.gpl3;
              maintainers = [ "andoriyu@gmail.com" ];
            };
          };
        };
        overlays = [ devshell.overlay rust-overlay.overlay overlay ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
      {
        overlay = overlay;
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

