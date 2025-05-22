{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:
buildGoModule rec {
  pname = "mcp-language-server";
  version = "unstable-2025-05-28"; # commit date for searchability

  src = fetchFromGitHub {
    owner = "isaacphi";
    repo = "mcp-language-server";
    rev = "46e2950b7969334780675e7797e13f140d2d42ac"; # Pinned to specific commit from 2025-05-22
    sha256 = "sha256-T0wuPSShJqVW+CcQHQuZnh3JOwqUxAKv1OCHwZMr7KM=";
  };

  vendorHash = "sha256-3NEG9o5AF2ZEFWkA9Gub8vn6DNptN6DwVcn/oR8ujW0=";
  subPackages = ["."];

  # strip debug info
  ldflags = ["-s" "-w"];

  meta = {
    description = "Model Context Protocol language-server wrapper";
    homepage = "https://github.com/isaacphi/mcp-language-server";
    license = lib.licenses.bsd3;
    maintainers = ["andoriyu@gmail.com"];
  };
}
