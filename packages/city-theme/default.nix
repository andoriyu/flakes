{ lib, stdenv, fetchFromGitHub, gtk-engine-murrine }:


stdenv.mkDerivation rec {
  pname = "City";
  version = "0.0.20201019";

  srcs = [
    (fetchFromGitHub {
      owner = "tsbarnes";
      repo = "City";
      rev = "e9eda815954192794b35772be887c7cab192be1c";
      sha256 = "188rbzznf1bafy19f3zmqaszkscgf55v5sig8wfi3flmqcmw0ywg";
    })
  ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    ls -lsa
    mkdir -p $out/share/themes
    mkdir -p $out/share/icons
    cp -a GTK/City $out/share/themes
    cp -a Icons $out/share/icons
  '';

  meta = with lib; {
    description = "A stylish pastel theme for GNOME";
    homepage = "https://github.com/tsbarnes/City";
    platforms = platforms.linux;
  };
}
