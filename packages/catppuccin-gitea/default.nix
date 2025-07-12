{
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "catppuccin-gitea";
  version = "1.0.2";

  src = fetchurl {
    url = "https://github.com/catppuccin/gitea/releases/download/v${version}/catppuccin-gitea.tar.gz";
    sha256 = "sha256-HP4Ap4l2K1BWP1zWdCKYS5Y5N+JcKAcXi+Hx1g6MVwc=";
  };

  dontBuild = true;
  dontConfigure = true;

  # The archive extracts files directly without creating a directory
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/css
    cp -r *.css $out/css/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Soothing pastel theme for Gitea";
    homepage = "https://github.com/catppuccin/gitea";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
