{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  python3Packages,
}: let
  # Define versions and tags for each server based on git tags
  serverInfo = {
    "mcp-neo4j-cypher" = {
      version = "0.2.1";
      tag = "mcp-neo4j-cypher-v0.2.1";
      dependencies = [
        "mcp[cli]>=1.6.0"
        "neo4j>=5.26.0"
        "pydantic>=2.10.1"
      ];
    };
    "mcp-neo4j-memory" = {
      version = "0.1.3";
      tag = "mcp-neo4j-memory-v0.1.3";
      dependencies = [
        "mcp>=0.10.0"
        "neo4j>=5.26.0"
      ];
    };
    "mcp-neo4j-cloud-aura-api" = {
      version = "0.2.2";
      tag = "mcp-neo4j-aura-manager-v0.2.2";
      dependencies = [
        "mcp>=1.6.0"
        "requests>=2.31.0"
      ];
      # The package name in pyproject.toml is different from the directory name
      pname = "mcp-neo4j-aura-manager";
    };
  };

  # Build function for each server
  buildServer = name: {
    inherit name;
    value = python3Packages.buildPythonApplication {
      inherit (serverInfo.${name}) version;
      pname = serverInfo.${name}.pname or name;

      src = fetchFromGitHub {
        owner = "neo4j-contrib";
        repo = "mcp-neo4j";
        rev = serverInfo.${name}.tag;
        sha256 = "sha256-homihdVoOj7dO6bn5DffozK47X8pHwzLPvnSnfbF2so=";
      };

      sourceRoot = "source/servers/${name}";

      format = "pyproject";

      propagatedBuildInputs = with python3Packages; [
        # Common dependencies
        pydantic

        # Add specific dependencies based on the server
        (
          if name == "mcp-neo4j-cypher"
          then [
            # For mcp-neo4j-cypher
            neo4j
            mcp
          ]
          else if name == "mcp-neo4j-memory"
          then [
            # For mcp-neo4j-memory
            neo4j
            mcp
          ]
          else [
            # For mcp-neo4j-cloud-aura-api
            requests
            mcp
          ]
        )
      ];

      nativeBuildInputs = with python3Packages; [
        hatchling
      ];

      meta = with lib; {
        description = "Neo4j MCP Server for ${name}";
        homepage = "https://github.com/neo4j-contrib/mcp-neo4j";
        license = licenses.mit;
        platforms = platforms.all;
      };
    };
  };

  servers = builtins.attrNames serverInfo;
in
  builtins.listToAttrs (map buildServer servers)
