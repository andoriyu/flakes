final: prev:
{
  cargo-expand-nightly = import ./packages/cargo-expand { inherit final prev; };
}
