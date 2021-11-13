final: prev: {
  andoriyu-ra = let
    base = prev.pkgs.rust-bin.stable.latest;
    rust = final.recurseIntoAttrs (final.makeRustPlatform {
      rustc = base.default;
      cargo = base.default;
    });
    ra-2021-11-08 = final.callPackage ./packages/rust-analyzer/generic.nix rec {
      pkgs = prev;
      rustPlatform = rust;
      rev = "2021-11-08";
      version = "unstable-${rev}";
      sha256 = "sha256-nqRK5276uTKOfwd1HAp4iOucjka651MkOL58qel8Hug=";
      cargoSha256 = "sha256-xA3PYbo/+2S6T50fzELg+uZA9wUfe3clK97+KxcHUCQ=";
    };
  in {
    rust-analyzer-unwrapped = {
      latest = ra-2021-11-08;
      "2021-11-08" = ra-2021-11-08;
    };
    rust-analyzer = {
      latest = final.callPackage ./packages/rust-analyzer/wrapper.nix { } {
        unwrapped = ra-2021-11-08;
      };
      "2021-11-08" =
        final.callPackage ./packages/rust-analyzer/wrapper.nix { } {
          unwrapped = ra-2021-11-08;
        };

    };
  };
}
