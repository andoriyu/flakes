{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  jq,
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

  postPatch = ''
    ${jq}/bin/jq '.packages["node_modules/router/node_modules/path-to-regexp"] += {
      resolved: "https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-8.2.0.tgz",
      integrity: "sha512-TdrF7fW9Rphjq4RjrW0Kp2AW0Ahwu9sRGTkS6bvDi0SCwZlEZYmcfDbEsTz8RVk0EHIS/Vd1bv3JhG+1xZuAyQ=="
    }' package-lock.json > package-lock.json.new
    mv package-lock.json.new package-lock.json
  '';

  npmDepsHash = "sha256-YV7+QdQwrQslj4Tw6lGEiLiYUe4NdfUotF2UxJGZe4I=";

  doCheck = false;

  meta = with lib; {
    description = "Visual testing tool for MCP servers";
    homepage = "https://github.com/modelcontextprotocol/inspector";
    license = licenses.mit;
    maintainers = ["andoriyu@gmail.com"];
    platforms = platforms.all;
  };
}
