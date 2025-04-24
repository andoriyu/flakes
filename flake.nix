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

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , fenix
    , pre-commit-hooks
    ,
    }:
    let
      # ---------------------------------------------------------------------
      # Platforms we build for
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

      # ---------------------------------------------------------------------
      # Overlay: replace Torch/Torchaudio with Metal-enabled wheels on Apple
      #          silicon; leave everything unchanged elsewhere.
      mpsOverlay = final: prev:
        if prev.stdenv.isDarwin && prev.stdenv.isAarch64
        then {
          python311Packages =
            let
              p = prev.python311Packages;
            in
            p
            // {
              torch = p.torch-bin;
              torchaudio = p.torchaudio-bin;
            };
        }
        else { };
    in
    flake-utils.lib.eachSystem systems (system:
    let
      overlays = [ mpsOverlay ];

      pkgs = import nixpkgs {
        inherit system overlays;
        # Needed for EnCodec’s CC-BY-NC licence
        config.allowUnfree = true;
      };

      packages = import ./packages.nix { inherit system pkgs fenix; };

      # -------------------------- Bark CLI wrapper -----------------------
      barkCli =
        let
          py = pkgs.python311.withPackages (ps: [ packages.bark ]);
        in
        pkgs.writeShellApplication {
          name = "bark";

          # A single runtime input: the enriched interpreter
          runtimeInputs = [ py ];

          text = ''
            exec python -m bark "$@"
          '';
        };
    in
    {
      inherit packages;

      # ------------------------ pre-commit checks -----------------------
      checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          nixpkgs-fmt.enable = true;
          shellcheck.enable = true;
          statix.enable = true;
        };
      };

      # --------------------------- dev shell ----------------------------
      devShell = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };

      # ----------------------------- apps -------------------------------
      apps.bark = flake-utils.lib.mkApp { drv = barkCli; };
    });
}
