{
  lib,
  fetchFromGitHub,
  buildDartPackage,
  sha256 ? "9f4102b45fbeaaa0f24d302f85b6139c1db1871a2a31c24ec2ff79e43da007e4",
  version ? "1.24.4",
  lockFile,
}:
buildDartPackage rec {
  pname = "dart-sass";
  inherit version;

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
    sha256 = "${sha256}";
  };

  specFile = "${src}/pubspec.yaml";
  inherit lockFile;

  meta = with lib; {
    description = "The reference implementation of Sass, written in Dart";
    homepage = "https://sass-lang.com/dart-sass";
    maintainers = ["andoriyu@gmail.com"];
    license = licenses.mit;
  };
}
