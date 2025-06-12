{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  ...
}:
buildNpmPackage rec {
  pname = "mcp-inspector";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "inspector";
    rev = version;
    sha256 = "sha256-Yelijo9YIpZXotXhaxduNaP++8uKUaGnx59KsVeEpNc=";
  };

  npmDepsHash = "sha256-ZM+CQiVndi+5lVD2EH9imzPCNPtXATPMHe2xK8grUBs=";

  doCheck = false;

  meta = with lib; {
    description = "Visual testing tool for MCP servers";
    homepage = "https://github.com/modelcontextprotocol/inspector";
    license = licenses.mit;
    maintainers = ["andoriyu@gmail.com"];
    platforms = platforms.all;
  };
}
