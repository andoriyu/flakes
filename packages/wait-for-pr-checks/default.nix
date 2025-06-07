{
  lib,
  stdenv,
  makeWrapper,
  gh,
  jq,
  bats,
}:
stdenv.mkDerivation {
  pname = "wait-for-pr-checks";
  version = "0.1.0";

  src = ../../scripts/bin/wait-for-pr-checks;

  nativeBuildInputs = [makeWrapper];
  nativeCheckInputs = [bats];
  doCheck = true;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/wait-for-pr-checks
    chmod +x $out/bin/wait-for-pr-checks
    wrapProgram $out/bin/wait-for-pr-checks \
      --prefix PATH : ${lib.makeBinPath [gh jq]}
  '';

  checkPhase = ''
    bats ${./tests/wait-for-pr-checks.bats}
  '';

  meta = with lib; {
    description = "Monitor GitHub PR checks with exponential backoff";
    longDescription = ''
      A utility script that monitors GitHub PR checks with exponential backoff
      until completion or timeout. Provides a nice formatted table display
      with color-coded output for better visibility.
    '';
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = [];
  };
}
