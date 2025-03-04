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
    sha256 = "sha256-NBjAH5O4CCY8tTIuvbXqbDJ+ggs77I9Yq9xocD01RmA=";
  };

  cargoSha256 = "sha256-4ZueSJ0SZ9SgZQ1IrwA7U6nhPZvnqtmoaRzS+cPa7zc=";
  meta = with lib; {
    description = "Lightweight private cargo registry with batteries included, built for organisations";
    homepage = "https://github.com/cenotelie/cratery";
    license = licenses.mit;
    maintainers = [ "andoriyu@gmail.com" ];
  };
}
