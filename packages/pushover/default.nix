{
  lib,
  stdenv,
  makeWrapper,
  curl,
}:
stdenv.mkDerivation {
  pname = "pushover-cli";
  version = "0.1.0";

  src = ./pushover;

  nativeBuildInputs = [makeWrapper];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/pushover
    chmod +x $out/bin/pushover
    wrapProgram $out/bin/pushover \
      --prefix PATH : ${lib.makeBinPath [curl]}
  '';

  meta = with lib; {
    description = "Command-line client for Pushover notifications";
    homepage = "https://pushover.net/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [andoriyu];
  };
}
