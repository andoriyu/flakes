When setting up this project, we found that Nix was not pre-installed.
Install Nix using Determinate Systems installer:

```
curl --proto '=https' --tlsv1.2 -sSfL https://install.determinate.systems/nix | sh -s -- install
```
Accept the prompts to use Determinate Nix.

After installation, ensure flakes work by running:

```
NIX_PROGRESS_STYLE=quiet nix flake show
```

This will display the flake outputs and confirms the environment is ready.
