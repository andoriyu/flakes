{ lib, rustPlatform, fetchFromGitea, ... }:

rustPlatform.buildRustPackage rec {
  pname = "readable-name-generator";
  version = "4.3.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "PurpleBooth";
    repo = "readable-name-generator";
    rev = "v4.3.3";
    sha256 = "sha256-xE0j8qjMDRKajR1EJfGLw3eKgvbQEHTUwGzTqVr4CL0=";
  };

  cargoHash = "sha256-FJNXC6Ab8t6Lq/6fUxHUGpsjkircP4A4L6fZN3Ig2WI=";

  meta = with lib; {
    description = "Generate a readable name for throwaway infrastructure";
    homepage = "https://codeberg.org/PurpleBooth/readable-name-generator";
    license = licenses.cc0;
    maintainers = [];
  };
}
