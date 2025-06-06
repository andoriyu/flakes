{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "mcp-prompts";
  version = "1.2.39";

  src = fetchFromGitHub {
    owner = "sparesparrow";
    repo = "mcp-prompts";
    rev = "v${version}";
    sha256 = "1p97pq0an7wpn77mbcvsxq45qdlxcpvmba05d0w1flfic5amx5wq";
  };

  npmDepsHash = "sha256-/YAsE26OV2dBDqSVEdVIB7guNRCmHlQtFTcZwGprqd4=";

  meta = with lib; {
    description = "An MCP server for managing prompts and prompt templates";
    homepage = "https://github.com/sparesparrow/mcp-prompts";
    license = licenses.mit;
    mainProgram = "mcp-prompts";
  };
}
