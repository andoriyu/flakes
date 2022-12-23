{ lib, buildGoModule, fetchFromGitHub }:
buildGoModule rec {
  pname = "atlas";
  version = "0.3.7";
  src = fetchFromGitHub {
    owner = "ariga";
    repo = "atlas";
    rev = "v${version}";
    sha256 = "sha256-psYAZ4ed3mc8HHgym/2lT1RrK6gO9n6QGYftwHIzNWI=";
  };
  vendorSha256 = "sha256-CJgAknV8IsvTaqToWrTfw17yI7isJe3u4UqyvT5kJWA=";
  doCheck = false;
  subPackages = [ "cmd/atlas" ];
  meta = with lib; {
    description =
      "Atlas is a CLI designed to help companies better work with their data.";
    homepage = "https://github.com/ariga/atlas";
    license = licenses.asl20;
    maintainers = [ "andoriyu@gmail.com" ];
  };

  postInstall = ''
    # remove all plugins, they are part of the main binary now
    for i in $out/bin/*; do
      if [[ $(basename $i) != atlas ]]; then
        rm "$i"
      fi
    done
  '';
}
