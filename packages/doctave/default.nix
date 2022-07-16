{ lib, rustPlatform, fetchFromGitHub, ... }:
rustPlatform.buildRustPackage rec {
  pname = "doctave";
  version = "0.4.2";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "doctave";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-8mGSFQozyLoGua9mwyqfDcYNMtbeWp9Phb0vaje+AJ0=";
  };

  cargoSha256 = "sha256-W/I5UilHXjFtmwialnAOyI3M1XBU2CSv7XwGbXje4HQ=";
  meta = with lib; {
    description = "Doctave is an opinionated documentation site generator that converts your Markdown files into a beautiful documentation site with minimal effort.";
    homepage = "https://github.com/doctave/doctave";
    license = licenses.mit;
    maintainers = [ "andoriyu@gmail.com" ];
  };
}
