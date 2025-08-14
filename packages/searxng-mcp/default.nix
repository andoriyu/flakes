{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  ...
}:
buildNpmPackage rec {
  pname = "searxng-mcp";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "tisDDM";
    repo = "searxng-mcp";
    rev = "e4b0fe297e3aac11554deae84d475d6eb6e51ac8";
    sha256 = "sha256-w5STFYeOIHMTyfz2ViAkV8GD/CzvWYUtWIz3l7Dpk3A=";
  };

  npmDepsHash = "sha256-2GD4wiNA1MNQmB4agJchXeSWTyYUptXogl3y6z0SKn4=";

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [nodejs]}"
  ];

  doCheck = false;

  meta = with lib; {
    mainProgram = "searxngmcp";
    description = "MCP server for performing web searches using SearXNG";
    homepage = "https://github.com/tisDDM/searxng-mcp";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
