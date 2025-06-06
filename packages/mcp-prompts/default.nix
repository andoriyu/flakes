{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  ...
}:
buildNpmPackage rec {
  pname = "mcp-prompts";
  version = "1.2.39";

  src = fetchFromGitHub {
    owner = "sparesparrow";
    repo = "mcp-prompts";
    rev = "v${version}";
    sha256 = "sha256-mJdeVWHRURc4aAWoVfdlnTZcCO56s1XPsZcfqwC+J90=";
  };

  npmDepsHash = "sha256-/YAsE26OV2dBDqSVEdVIB7guNRCmHlQtFTcZwGprqd4=";

  doCheck = false;

  meta = with lib; {
    description = "Model Context Protocol server for managing, storing, and providing prompts and prompt templates for LLM interactions";
    homepage = "https://github.com/sparesparrow/mcp-prompts";
    license = licenses.mit;
    maintainers = ["andoriyu@gmail.com"];
    platforms = platforms.all;
  };
}
