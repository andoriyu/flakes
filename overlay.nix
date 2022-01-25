final: prev:
{
  cargo-expand-nightly = import ./packages/cargo-expand { inherit final prev; };
  git-cliff = import ./packages/git-cliff { inherit final prev; };
  dart-sass = final.callPackage ./packages/dart-sass/default.nix {
    version = "1.49.0";
    sha256 = "701a1896383ac06f545f4fc70c0c945b98cff3d041d7dc44f322db8addcc1167";
  };
}
