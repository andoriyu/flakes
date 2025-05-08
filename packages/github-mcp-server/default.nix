{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v0.2.1";
    sha256 = "sha256-vbL96EXzgbjqVJaKizYIe8Fne60CVx7v/5ya9Xx3JvA=";
  };

  subPackages = ["cmd/github-mcp-server"];

  vendorHash = "sha256-LjwvIn/7PLZkJrrhNdEv9J6sj5q3Ljv70z3hDeqC5Sw=";

  # strip debugging symbols
  ldflags = ["-s" "-w"];

  meta = {
    description = "GitHub’s official Model Context Protocol server";
    homepage = "https://github.com/github/github-mcp-server";
    license = lib.licenses.mit;
    maintainers = ["andoriyu@gmail.com"];
  };
}
