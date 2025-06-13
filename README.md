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
```
## Cachix

```
cachix use andoriyu-flakes
```

NOTE: Not every package is cached. 

## Default devShell

  The same as `fat` template. Suitable for rust full-stack development. In addition it includes tools like [`cargo-expand`](https://github.com/dtolnay/cargo-expand) and [`git-cliff`](https://github.com/orhun/git-cliff). `cargo-expand` is wrapped to use latest nightly, so it will work regardless of active toolchain unlike version in `nixpkgs`.

## Packages in overlay

 - git-cliff
 - cargo-expand-nightly (a wrapper around `cargo-expand`)
 - mcp-neo4j-cypher (Neo4j MCP server for natural language to Cypher queries)
 - mcp-neo4j-memory (Neo4j MCP server for knowledge graph memory)
 - mcp-neo4j-cloud-aura-api (Neo4j MCP server for Aura cloud service management)
 - wait-for-pr-checks (Monitor GitHub PR checks with exponential backoff)

## Utility Scripts

 - wait-for-pr-checks: Monitor GitHub PR checks with exponential backoff. Run with `nix run .#wait-for-pr-checks`

## Neo4j plugin module

The flake exposes a small NixOS module that installs declared Neo4j plugins.
Include the module and list desired plugin packages via `services.neo4j.plugins`:

```nix
{ 
  imports = [ flakes.neo4j-plugins.nixosModules.neo4j-plugins ];

  services.neo4j = {
    enable = true;
    plugins = [ pkgs.neo4j-apoc ];
    # plugin configuration goes in extraServerConfig
  };
}
```

