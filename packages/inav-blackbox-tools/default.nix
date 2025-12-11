{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "inav-blackbox-tools";
  version = "9.0.0-rc1";

  src = fetchurl {
    url = "https://github.com/iNavFlight/blackbox-tools/releases/download/v${version}/blackbox-tools-${version}_linux-x64_64.tar.gz";
    hash = "sha256-ipMScErfJ2LfLSvJ0mZUxUplBy1puIokulfR2kfJwvQ=";
  };

  sourceRoot = ".";

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/share/bash-completion/completions

    install -m 755 bin/blackbox_decode $out/bin/
    install -m 644 share/bash-completion/completions/blackbox_decode $out/share/bash-completion/completions/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tools for working with INAV blackbox flight logs";
    longDescription = ''
      Command line tools to convert flight data logs recorded by INAV's
      Blackbox feature into CSV files (comma-separated values) for analysis.

      This package provides blackbox_decode for decoding INAV flight logs.
    '';
    homepage = "https://github.com/iNavFlight/blackbox-tools";
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    license = licenses.gpl3Only;
    platforms = ["x86_64-linux"];
    mainProgram = "blackbox_decode";
  };
}
