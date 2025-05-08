{
  lib,
  python311Packages,
  buildPythonPackage ? python311Packages.buildPythonPackage,
  fetchFromGitHub,
  encodec,
  torch ? python311Packages.torch,
  torchaudio ? python311Packages.torchaudio,
  ...
}: let
  pname = "suno-bark";
  # encode the commit date so `nix search` shows something meaningful
  version = "unstable-2024-04-05";
  commit = "f4f32d4cd480dfec1c245d258174bc9bde3c2148";
in
  buildPythonPackage {
    inherit pname version;
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "suno-ai";
      repo = "bark";
      rev = commit;
      sha256 = "sha256-GmQK+pJIwOqOo3vH5ktLqtJOOXtiXeGdeQ9bDlkmGBg="; # ← fix on 1st build
    };

    propagatedBuildInputs = with python311Packages; [
      boto3
      funcy
      huggingface-hub
      numpy
      scipy
      tokenizers
      torch
      torchaudio
      tqdm
      transformers
      encodec
    ];

    pythonImportsCheck = ["bark"];

    meta = {
      description = "Text-to-audio model Bark by Suno.ai";
      homepage = "https://github.com/suno-ai/bark";
      license = lib.licenses.mit;
      maintainers = ["andoriyu@gmail.com"];
    };
  }
