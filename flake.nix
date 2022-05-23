{
  description = "Flakey";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-dart = {
      url = "github:tadfisher/nix-dart";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils, nix-dart, fenix, ... }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
    in
    {
      templates."rust-lite" = { path = ./templates/rust-lite; description = "A light version of rust environment for devlopment"; };
      templates."rust-wasm" = { path = ./templates/rust-wasm; description = "A fat version of rust environment with nodejs for full-stack devlopment"; };
      templates."fat" = { path = ./templates/rust-wasm; description = "A fat version of development environment. Right now rust-wasm + some extra packages"; };
    } //
    flake-utils.lib.eachSystem systems (system:
      let
        overlays = [ nix-dart.overlay ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        rustPlatformNightly = (pkgs.makeRustPlatform {
          inherit (fenix.packages.${system}.minimal) cargo rustc;
        });
        rustPlatformStable = (pkgs.makeRustPlatform {
          inherit (fenix.packages.${system}.minimal) cargo rustc;
        });

      in
      with pkgs;
      {
        packages = rec {
          atlas = callPackage ./packages/atlas/default.nix { };
          dart-sass = dart-sass-1_52_1;
          git-cliff = callPackage ./packages/git-cliff { rustPlatform = rustPlatformStable; };
          cargo-expand-nightly = callPackage ./packages/cargo-expand { toolchain = fenix.packages.${system}.minimal; };
          dart-sass-1_52_1 = callPackage ./packages/dart-sass {
            version = "1.52.1";
          };
        };
      }
    );
}

