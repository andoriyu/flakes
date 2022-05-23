{lib, rustPlatform, fetchFromGitHub, ...}:
rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "0.7.0";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wVHL2+didmiN7UlEeIuSr+8LhkFKCOD3of4rKVg1i1o=";
  };

  cargoSha256 = "sha256-5jhloUnaGXXDu2LCO86SMJo8ETIxLAivv3hx9gEqtJ4=";
  meta = with lib; {
    description = "git-cliff can generate changelog files from the Git history by utilizing conventional commits as well as regex-powered custom parsers. The changelog template can be customized with a configuration file to match the desired format.";
    homepage = "https://github.com/orhun/git-cliff";
    license = licenses.gpl3;
    maintainers = [ "andoriyu@gmail.com" ];
  };
}
