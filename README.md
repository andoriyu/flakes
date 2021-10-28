# My personal Nix Flakes and stuff

Current flake looks like this:

```
├───devShell
│   ├───aarch64-darwin: development environment 'devshell'
│   ├───aarch64-linux: development environment 'devshell'
│   ├───i686-linux: development environment 'devshell'
│   ├───x86_64-darwin: development environment 'devshell'
│   └───x86_64-linux: development environment 'devshell'
├───overlay: Nixpkgs overlay
└───templates
    ├───fat: template: A fat version of development environment. Right now it's rust-wasm + some extra packages
    ├───rust-lite: template: A light version of rust environment for devlopment
    └───rust-wasm: template: A fat version of rust environment with nodejs for full-stack devlopment
```

## Default devShell

  The same as `fat` template. Suitable for rust full-stack development. In addition it includes tools like [`cargo-expand`](https://github.com/dtolnay/cargo-expand) and [`git-cliff`](https://github.com/orhun/git-cliff). `cargo-expand` is wrapped to use latest nightly, so it will work regardless of active toolchain unlike vesrion in `nixpkgs`.

## Packages in overlay

 - git-cliff
 - cargo-expand-nightly
