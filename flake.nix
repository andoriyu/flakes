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

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    fenix,
    pre-commit-hooks,
  }: let
    # ---------------------------------------------------------------------
    # Platforms we build for
    systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];

    # ---------------------------------------------------------------------
    # Overlay: replace Torch/Torchaudio with Metal-enabled wheels on Apple silicon
    mpsOverlay = final: prev:
      if prev.stdenv.isDarwin && prev.stdenv.isAarch64
      then {
        python311Packages = let
          p = prev.python311Packages;
        in
          p
          // {
            torch = p.torch-bin;
            torchaudio = p.torchaudio-bin;
          };
      }
      else {};

    # ---------------------------------------------------------------------
    # Overlay: add our custom packages (cargo-expand-nightly, dart-sass)
    customPackagesOverlay = final: prev: {
      inherit
        (self.packages.${prev.system})
        cargo-expand-nightly
        dart-sass
        ;
    };

    # ---------------------------------------------------------------------
    # Compose both overlays into one
    fullOverlay = final: prev: let
      a = mpsOverlay final prev;
      b = customPackagesOverlay final prev;
    in
      a // b;
  in
    # Expose the composed overlay at the top level
    {overlays.default = fullOverlay;}
    //
    # Create per-system outputs (packages, checks, devShell, apps)
    (flake-utils.lib.eachSystem systems (
      system: let
        # Import nixpkgs with our overlay
        pkgs = import nixpkgs {
          inherit system;
          overlays = [fullOverlay];
          # Needed for EnCodec’s CC-BY-NC licence
          config.allowUnfree = true;
        };

        # Import our package set for this system
        packages = import ./packages.nix {inherit system pkgs fenix;};

        # Build a simple shell application for Bark CLI
        barkCli = let
          py = pkgs.python311.withPackages (ps: [packages.bark]);
        in
          pkgs.writeShellApplication {
            name = "bark";
            runtimeInputs = [py];
            text = ''
              exec python -m bark "$@"
            '';
          };
      in {
        inherit packages;

        # ------------------------ pre-commit checks -----------------------
        checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
            shellcheck.enable = true;
            statix.enable = true;
          };
        };

        # Set Alejandra as the formatter for this flake
        formatter = pkgs.alejandra;

        # ------------------------- dev shell -----------------------------
        devShell = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };

        # --------------------------- apps -------------------------------
        apps.bark = flake-utils.lib.mkApp {drv = barkCli;};
      }
    ));
}
