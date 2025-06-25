{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  ...
}:
buildNpmPackage rec {
  pname = "gemini-cli";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
    rev = "52afcb3a1233237b07aa86b1678f4c4eded70800"; # early-access
    sha256 = "sha256-KNnfo5hntQjvc377A39+QBemeJjMVDRnNuGY/93n3zc=";
  };

  npmDepsHash = "sha256-/IAEcbER5cr6/9BFZYuV2j1jgA75eeFxaLXdh1T3bMA=";

  postInstall = ''
    rm -rf $out/lib/node_modules/gemini-cli/node_modules/@gemini-cli
    rm -f $out/lib/node_modules/gemini-cli/node_modules/.bin/gemini
  '';

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [nodejs]}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Gemini CLI for interacting with Google's Gemini models";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = licenses.asl20;
    maintainers = [];
    platforms = platforms.all;
  };
}
