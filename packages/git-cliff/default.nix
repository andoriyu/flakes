{final, prev, ...}:
let
  base = prev.pkgs.rust-bin.stable.latest;
  rustPlatform = final.recurseIntoAttrs (final.makeRustPlatform {
      rustc = base.minimal;
      cargo = base.minimal;
  });
in rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "0.4.2";

  doCheck = false;

  src = final.fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FCBNm51QI1jDdq2BZFwZA1kpIfXIvh1ickmY3ZqwGPY=";
  };

  cargoSha256 = "sha256-CBCyujJHWTatJO+Tk6MyOk12B0cY1JSwLQizjcXeQzQ=";

  meta = with final.lib; {
    description = "git-cliff can generate changelog files from the Git history by utilizing conventional commits as well as regex-powered custom parsers. The changelog template can be customized with a configuration file to match the desired format.";
    homepage = "https://github.com/orhun/git-cliff";
    license = licenses.gpl3;
    maintainers = [ "andoriyu@gmail.com" ];
  };
}
