{ lib, rustPlatform, fetchFromGitHub, ... }:
rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "0.8.1";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lRONRLTByhMalN9BKilCcQn2c9f4cxOnHJLL0l0jaOs=";
  };

  cargoSha256 = "sha256-1r/k3DQ/vjIjMpOHYCRRosbZ22iAFkuq4EbZUcZoWn0=";
  meta = with lib; {
    description =
      "git-cliff can generate changelog files from the Git history by utilizing conventional commits as well as regex-powered custom parsers. The changelog template can be customized with a configuration file to match the desired format.";
    homepage = "https://github.com/orhun/git-cliff";
    license = licenses.gpl3;
    maintainers = [ "andoriyu@gmail.com" ];
  };
}
