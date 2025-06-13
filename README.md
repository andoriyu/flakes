# My personal Nix Flakes and stuff

Current flake looks like this:

```
├───apps
│   ├───aarch64-darwin
│   │   ├───bark: app
│   │   └───wait-for-pr-checks: app
│   ├───aarch64-linux
│   │   ├───bark: app
│   │   └───wait-for-pr-checks: app
│   └───x86_64-linux
│       ├───bark: app
│       └───wait-for-pr-checks: app
├───devShell: development environment
├───devShells
│   ├───aarch64-darwin
│   │   ├───node-latest: development environment
│   │   ├───node-lts: development environment
│   │   └───rust: development environment
│   ├───aarch64-linux
│   │   ├───node-latest: development environment
│   │   ├───node-lts: development environment
│   │   └───rust: development environment
│   └───x86_64-linux
│       ├───node-latest: development environment
│       ├───node-lts: development environment
│       └───rust: development environment
├───nixosModules
│   └───neo4j-plugins: NixOS module
├───overlays
│   └───default: Nixpkgs overlay
└───packages
    ├───aarch64-darwin
    │   ├───bark
    │   ├───dart-sass
    │   ├───dart-sass-1_60_0
    │   ├───dart-sass-1_89_2
    │   ├───encodec
    │   ├───github-mcp-server
    │   ├───mcp-inspector
    │   ├───mcp-language-server
    │   ├───mcp-neo4j-cloud-aura-api
    │   ├───mcp-neo4j-cypher
    │   ├───mcp-neo4j-memory
    │   ├───mcp-prompts
    │   ├───neo4j-apoc
    │   └───wait-for-pr-checks
    ├───aarch64-linux
    │   ├───City
    │   ├───bark
    │   ├───dart-sass
    │   ├───dart-sass-1_60_0
    │   ├───dart-sass-1_89_2
    │   ├───encodec
    │   ├───github-mcp-server
    │   ├───mcp-inspector
    │   ├───mcp-language-server
    │   ├───mcp-neo4j-cloud-aura-api
    │   ├───mcp-neo4j-cypher
    │   ├───mcp-neo4j-memory
    │   ├───mcp-prompts
    │   ├───neo4j-apoc
    │   ├───st-onedark
    │   └───wait-for-pr-checks
    └───x86_64-linux
        ├───City
        ├───bark
        ├───dart-sass
        ├───dart-sass-1_60_0
        ├───dart-sass-1_89_2
        ├───encodec
        ├───github-mcp-server
        ├───mcp-inspector
        ├───mcp-language-server
        ├───mcp-neo4j-cloud-aura-api
        ├───mcp-neo4j-cypher
        ├───mcp-neo4j-memory
        ├───mcp-prompts
        ├───neo4j-apoc
        ├───st-onedark
        └───wait-for-pr-checks
```

## Cachix

```
cachix use andoriyu-flakes
```

NOTE: Not every package is cached. 

## Default devShell

A development environment with pre-commit hooks configured for:
- alejandra (Nix formatter)
- shellcheck (shell script linter)
- statix (Nix static analysis)

## Additional devShells

The flake exposes a few specialized shells:

- `node-latest` – latest Node.js with common tooling (`yarn`, `pnpm`,
  `typescript`, `ts-node`, `eslint`, `prettier`) and `wait-for-pr-checks`.
- `node-lts` – Node.js LTS release with the same Node.js tooling as above
  and `wait-for-pr-checks`.
- `rust` – tools for Rust development (`rustc`, `cargo`, `rustfmt`, `clippy`,
  `rust-analyzer`, `cargo-expand`, `git-cliff`, `bacon`) plus
  `wait-for-pr-checks`.

## Packages in overlay

- `bark` - Suno's text-to-audio model
- `City` - A C++ header-only library for comfortable urban-scale navigation
- `dart-sass` - Latest version of Dart Sass
- `dart-sass-1_60_0` - Dart Sass 1.60.0
- `dart-sass-1_89_2` - Dart Sass 1.89.2
- `encodec` - Neural audio codec from Meta
- `github-mcp-server` - MCP server for GitHub API integration
- `mcp-inspector` - Inspector tool for MCP servers
- `mcp-language-server` - Language server for MCP protocol
- `mcp-neo4j-cloud-aura-api` - Neo4j MCP server for Aura cloud service management
- `mcp-neo4j-cypher` - Neo4j MCP server for natural language to Cypher queries
- `mcp-neo4j-memory` - Neo4j MCP server for knowledge graph memory
- `mcp-prompts` - Collection of MCP prompts
- `neo4j-apoc` - Neo4j APOC plugin
- `st-onedark` - St terminal with OneDark theme
- `wait-for-pr-checks` - Monitor GitHub PR checks with exponential backoff

## Apps

- `bark` - Run Suno's text-to-audio model
- `wait-for-pr-checks` - Monitor GitHub PR checks with exponential backoff

## Utility Scripts

- `wait-for-pr-checks`: Monitor GitHub PR checks with exponential backoff. Run with `nix run .#wait-for-pr-checks`

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
