{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "grit";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "honeycombio";
    repo = "gritql";
    rev = "1477fecd90e967b7e298dc3e75ff6ed103e152a8";
    sha256 = "sha256-ZtBdM7qA4QOAxJ6eREmremjnFJm+CYgZCMnwczmPmyc=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-UGZ5J/7DeA847p700EMywxVMnmv1In00mgmd3rlKFuU=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl];

  meta = with lib; {
    description = "GritQL CLI for querying and rewriting source code";
    homepage = "https://github.com/honeycombio/gritql";
    license = licenses.mit;
    mainProgram = "grit";
    maintainers = [];
  };
}
