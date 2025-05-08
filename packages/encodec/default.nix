{
  lib,
  python311Packages,
  buildPythonPackage ? python311Packages.buildPythonPackage,
  # ▲ default helper
  fetchPypi ? python311Packages.fetchPypi,
  # ▲ default helper
  torch ? python311Packages.torch,
  # ▲ becomes torch-bin on M-series
  torchaudio ? python311Packages.torchaudio,
  # ▲ becomes torchaudio-bin on M-series
  ...
}: let
  pname = "encodec";
  version = "0.1.1"; # latest on PyPI
in
  buildPythonPackage {
    inherit pname version;
    format = "pyproject";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-Nt3pjM/mxRoVV2R2yt/LOzWmNQe4uFVavWmImm+6Z3I=";
    };

    propagatedBuildInputs = [
      torch
      torchaudio
      python311Packages.einops
      python311Packages.numpy
    ];

    pythonImportsCheck = ["encodec"];

    meta = {
      description = "High-fidelity neural audio codec (Meta AI)";
      homepage = "https://github.com/facebookresearch/encodec";
      license = lib.licenses.cc-by-nc-40;
      maintainers = ["andoriyu@gmail.com"];
    };
  }
