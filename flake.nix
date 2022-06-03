{
  description = "Flakey";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, flake-utils, fenix, pre-commit-hooks }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
    in
    flake-utils.lib.eachSystem systems (system:
      let
        overlays = [ ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        rustPlatformStable = pkgs.makeRustPlatform {
          inherit (fenix.packages.${system}.stable) cargo rustc;
        };
        rustNightlyToolchain = fenix.packages.${system}.toolchainOf {
          date = "2022-05-25";
          sha256 = "sha256-zjx9Ogl5ZyJOWq/1byndSStGQiIzmw0NamzmVGmUZbY=";
        }; # Specific date to avoid recompilcation every day
      in
      with pkgs;
      {
        packages = rec {
          atlas = callPackage ./packages/atlas/default.nix { };
          dart-sass = dart-sass-1_52_2;
          git-cliff = callPackage ./packages/git-cliff { rustPlatform = rustPlatformStable; };
          cargo-expand-nightly = callPackage ./packages/cargo-expand { toolchain = rustNightlyToolchain; };
          dart-sass-1_52_1 = callPackage ./packages/dart-sass {
            version = "1.52.1";
          };
          dart-sass-1_52_2 = callPackage ./packages/dart-sass {
            version = "1.52.2";
          };
        };
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
              shellcheck.enable = true;
              statix.enable = true;
              nix-linter.enable = true;
            };
          };
        };
        devShell = nixpkgs.legacyPackages.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      }
    );
}

