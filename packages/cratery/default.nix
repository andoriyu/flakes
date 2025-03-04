{ lib
, rustPlatform
, fetchFromGitHub
, ...
}:
rustPlatform.buildRustPackage rec {
  pname = "cratery";
  version = "1.11.1";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "cenotelie";
    repo = pname;
    rev = "v${version}";
    sha256 = "${lib.fakeSha256}";
  };

  cargoSha256 = "${lib.fakeSha256}";
  meta = with lib; {
    description = "Lightweight private cargo registry with batteries included, built for organisations";
    homepage = "https://github.com/cenotelie/cratery";
    license = licenses.mit;
    maintainers = [ "andoriyu@gmail.com" ];
  };
}
