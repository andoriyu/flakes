final: prev:
{
  cargo-expand-nightly = import ./packages/cargo-expand { inherit final prev; };
  git-cliff = import ./packages/git-cliff { inherit final prev; };
}
