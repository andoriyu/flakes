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
    rev = "main"; # pin a SHA for full reproducibility
    sha256 = "sha256-WCQH/eNYA8bSJwn3OPlhpEMuFua3fC8QCBIg3H4Yokk=";
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
